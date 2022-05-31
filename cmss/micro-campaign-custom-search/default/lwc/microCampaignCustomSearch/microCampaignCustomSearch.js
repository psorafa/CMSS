import { LightningElement, wire } from 'lwc';
import searchResults from '@salesforce/apex/CustomSearchController.searchResults';
import loadFieldsetDetail from '@salesforce/apex/CustomSearchController.loadFieldsetDetail';
import loadTypeList from '@salesforce/apex/CustomSearchController.loadTypeList';
import createMicroCampaign from '@salesforce/apex/CustomSearchController.createMicroCampaign';

import LBL_AccountSearchType from '@salesforce/label/c.AccountSearchType';
import LBL_AssetSearchType from '@salesforce/label/c.AssetSearchType';
import LBL_SearchButton from '@salesforce/label/c.SearchButton';
import LBL_INVALID_REQUEST_TITLE from '@salesforce/label/c.ValidateErrorTitle';
import LBL_INVALID_REQUEST_MESSAGE from '@salesforce/label/c.InvalidRequestMissingRequiredParameters';
import LBL_SEARCH_SECTION_TITLE from '@salesforce/label/c.SearchSectionTitle';
import LBL_DATA_SECTION_TITLE from '@salesforce/label/c.DataSectionTitle';
import LBL_NEXT_PAGE_BUTTON_TITLE from '@salesforce/label/c.NextPageButtonTitle';
import LBL_PREV_PAGE_TITLE from '@salesforce/label/c.PrevPageButtonTitle';
import LBL_CREATE_CAMPAIGN_BUTTON_TITLE from '@salesforce/label/c.CreateMicroCampaignButtonTitle';
import LBL_CREATE_CAMPAIGN_MODAL_TITLE from '@salesforce/label/c.CreateMicroCampaignModalWindowTitle';
import LBL_RECORDS_PER_PAGE_TITLE from '@salesforce/label/c.RecordsPerPageInputTitle';
import LBL_TOTAL_RECORDS_COUNT_LABEL from '@salesforce/label/c.TotalRecordsCountLabel';
import LBL_NO_DATA_TITLE from '@salesforce/label/c.NoDataLoaded';
import LBL_FILL_REQUIRED_FIELDS_MESSAGE from '@salesforce/label/c.FillRequiredFieldsMessage';
import LBL_CREATE_NEW_RECORDS_BUTTON_TITLE from '@salesforce/label/c.CreateRecords';
import LBL_CLOSE_MODAL_WINDOW_TITLE from '@salesforce/label/c.CloseModalWindow';
import LBL_CANCEL_BUTTON_TITLE from '@salesforce/label/c.CancelButtonTitle';
import LBL_UNSUPPORTED_OBJECT_TYPE_ERROR_MESSAGE from '@salesforce/label/c.UnsupportedObjectType';
import LBL_RECORDS_CREATED_MESSAGE from '@salesforce/label/c.RecordSuccessfullyCreated';
import LBL_LOAD_PRODUCT_TYPES_ERROR_MESSAGE from '@salesforce/label/c.LoadingProductTypesError';
import LBL_NO_RECORDS from '@salesforce/label/c.NoRecordsFound';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MicroCampaignCustomSearch extends LightningElement {
	selectedUserHierarchy = [];
	filterConditionList = [];
	selectedConfiguration;
	selectedObjectType;
	selectedProduct;
	availableTypes;
	section = ['configuration'];
	isModalOpen = false;
	selectedAccountIds = [];

	totalRecordsCount = 0;
	recordsPerPage = 2000;

	outputTableColumns = [];
	outputTableData = [];
	loading = false;
	dataInvalid = false;

	labels = {
		LBL_AccountSearchType,
		LBL_AssetSearchType,
		LBL_SearchButton,
		LBL_SEARCH_SECTION_TITLE,
		LBL_DATA_SECTION_TITLE,
		LBL_CREATE_CAMPAIGN_BUTTON_TITLE,
		LBL_CREATE_CAMPAIGN_MODAL_TITLE,
		LBL_RECORDS_PER_PAGE_TITLE,
		LBL_TOTAL_RECORDS_COUNT_LABEL,
		LBL_NO_DATA_TITLE,
		LBL_NEXT_PAGE_BUTTON_TITLE,
		LBL_PREV_PAGE_TITLE,
		LBL_FILL_REQUIRED_FIELDS_MESSAGE,
		LBL_CREATE_NEW_RECORDS_BUTTON_TITLE,
		LBL_CLOSE_MODAL_WINDOW_TITLE,
		LBL_CANCEL_BUTTON_TITLE
	};

	@wire(loadTypeList)
	loadTypeList({ error, data }) {
		if (data) {
			this.availableTypes = data;
		} else if (error) {
			console.log(JSON.stringify(error));
			this.errorToastMessage(LBL_LOAD_PRODUCT_TYPES_ERROR_MESSAGE, error.body.message);
		}
	}

	handleSelectProduct(event) {
		const newSelectProduct = event.target.dataset.product;
		const newSelectObject = event.target.dataset.object;
		if (newSelectProduct !== this.selectedProduct) {
			this.outputTableColumns = [];
			this.selectedUserHierarchy = [];
			this.selectedConfiguration = null;
			this.selectedProduct = newSelectProduct;
			this.selectedObjectType = newSelectObject;
		}
	}

	get isTypeSelected() {
		return this.selectedConfiguration != null;
	}

	handleUserHierarchySelectionChange(event) {
		this.selectedUserHierarchy = event.detail;
	}

	handleUpdateFilterConditions(event) {
		this.filterConditionList = event.detail.filterItems;
	}

	handleSelectConfiguration(event) {
		this.selectedConfiguration = event.detail;
	}

	addSelectedUsersToFilter() {
		let ownerFieldName = this.selectedConfiguration.OwnerFieldName__c;
		if (this.selectedUserHierarchy.length > 0) {
			let filters = [{ type: 'IN', value: "('" + this.selectedUserHierarchy.join("','") + "')" }];
			this.addToFilter(ownerFieldName, filters, 'Array');
		} else {
			this.removeFilter(ownerFieldName);
		}
	}

	removeFilter(inputFieldName) {
		const existingItem = this.filterConditionList.filter(
			item =>
				item.fieldName === inputFieldName &&
				item.objectName === this.selectedObjectType &&
				item.productType === this.selectedProduct
		);

		if (existingItem.length >= 1) {
			this.filterConditionList = this.filterConditionList.reduce((acc, item) => {
				if (
					item.fieldName === inputFieldName &&
					item.objectName === this.selectedObjectType &&
					item.productType === this.selectedProduct
				) {
					this.filterConditionList.splice(this.filterConditionList.indexOf(item), 1);
				}
				return acc;
			}, []);
		}
	}

	addRecordTypeFilter() {
		let recordTypeFieldName = 'RecordType.DeveloperName';
		const filters = [{ type: '=', value: this.selectedProduct }];
		this.addToFilter(recordTypeFieldName, filters, 'Text');
	}

	addToFilter(inputFieldName, filterValue, dataType) {
		const existingItem = this.filterConditionList.filter(
			item =>
				item.fieldName === inputFieldName &&
				item.objectName === this.selectedObjectType &&
				item.productType === this.selectedProduct
		);

		if (existingItem.length >= 1) {
			existingItem[0].filters = filterValue;
		} else {
			const recordTypeFilter = {
				fieldName: inputFieldName,
				objectName: this.selectedObjectType,
				productType: this.selectedProduct,
				dataType: dataType,
				filters: filterValue
			};
			this.filterConditionList.push(recordTypeFilter);
		}
	}

	handleSubmitSearch() {
		if (this.isRequestNotValid) {
			this.errorToastMessage(LBL_INVALID_REQUEST_TITLE, LBL_INVALID_REQUEST_MESSAGE);
			return;
		}
		this.addSelectedUsersToFilter();
		this.addRecordTypeFilter();
		this.loading = true;
		const request = {
			filterItemList: this.filterConditionList,
			configuration: this.selectedConfiguration,
			objectName: this.selectedConfiguration.ObjectType__c,
			pageSize: this.recordsPerPage
		};

		console.log('request: ' + JSON.stringify(request));
		const currentSelectedAccountIds = this.selectedAccountIds;

		searchResults({ dto: request })
			.then(response => {
				this.outputTableData = response.data;
				this.selectedAccountIds = currentSelectedAccountIds;
				this.totalRecordsCount = response.data.length;

				if (this.totalRecordsCount < 1) {
					this.toastMessage(null, '', LBL_NO_RECORDS);
					return;
				}

				loadFieldsetDetail({
					fieldsetName: this.selectedConfiguration.FieldsetName__c,
					objectName: request.objectName
				})
					.then(colResponse => {
						this.outputTableColumns = colResponse;
						if (this.isTableVisible) {
							this.section = ['data'];
						} else {
							this.section = ['configuration'];
						}
					})
					.catch(error => {
						console.log(JSON.stringify(error));
						this.errorToastMessage('', error.body.message);
					});
			})
			.catch(error => {
				console.log(JSON.stringify(error));
				this.errorToastMessage('', error.body.message);
			})
			.finally(() => {
				this.loading = false;
			});
	}

	get isRequestNotValid() {
		return this.selectedConfiguration == null;
	}

	get isTableVisible() {
		return this.outputTableColumns.length > 0;
	}

	errorToastMessage(title, message) {
		this.toastMessage('error', title, message, 'sticky');
	}

	toastMessage(variant, title, message, mode) {
		const evt = new ShowToastEvent({
			variant: variant,
			title: title,
			message: message,
			mode: mode
		});
		this.dispatchEvent(evt);
	}

	handleSelectedRows(event) {
		const selectedRows = event.detail.selectedRows;
		if (this.selectedConfiguration.ObjectType__c === 'Account') {
			this.selectedAccountIds = selectedRows.map(row => row.Id);
		} else if (this.selectedConfiguration.ObjectType__c === 'Asset') {
			this.selectedAccountIds = selectedRows.map(row => row.AccountId);
		} else {
			this.errorToastMessage('', LBL_UNSUPPORTED_OBJECT_TYPE_ERROR_MESSAGE);
		}
	}

	get isRowNotSelected() {
		return this.selectedAccountIds.length === 0;
	}

	handleShowCreateMicroCampaign() {
		this.isModalOpen = true;
	}

	handleFormChange(event) {
		this.dataInvalid = !event.detail.valid;
		this.formData = event.detail.data;
	}

	handleCreateClick() {
		const requestData = {
			ids: this.selectedAccountIds,
			...this.formData
		};
		this.loading = true;
		createMicroCampaign({ data: requestData })
			.then(() => {
				this.toastMessage('success', '', LBL_RECORDS_CREATED_MESSAGE);
			})
			.catch(error => {
				console.log(JSON.stringify(error));
				this.errorToastMessage('', error.body.message);
			})
			.finally(() => {
				this.isModalOpen = false;
				this.loading = false;
				this.selectedAccountIds = [];
			});
	}

	closeModal() {
		this.isModalOpen = false;
		this.loading = false;
	}

	handleSectionToggle(event) {
		this.section = event.detail.openSections;
	}

	get filtersJson() {
		return JSON.stringify(this.filterConditionList);
	}

	get selectedProductJson() {
		return JSON.stringify(this.selectedProduct);
	}
}
