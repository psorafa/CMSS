import { LightningElement, wire } from 'lwc';
import searchResults from '@salesforce/apex/CustomSearchController.searchResults';
import countResults from '@salesforce/apex/CustomSearchController.countResults';
import loadFieldsetDetail from '@salesforce/apex/CustomSearchController.loadFieldsetDetail';
import loadTypeList from '@salesforce/apex/CustomSearchController.loadTypeList';
import createMicroCampaign from '@salesforce/apex/CustomSearchController.createMicroCampaign';
import getAllAccountId from '@salesforce/apex/CustomSearchController.getAllAccountId';

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
import LBL_CREATE_PMR_BUTTON_TITLE from '@salesforce/label/c.NewPortfolioManagementChangeRequest';
import LBL_CREATE_CAMPAIGN_MODAL_TITLE from '@salesforce/label/c.CreateMicroCampaignModalWindowTitle';
import LBL_RECORDS_PER_PAGE_TITLE from '@salesforce/label/c.RecordsPerPageInputTitle';
import LBL_TOTAL_RECORDS_COUNT_LABEL from '@salesforce/label/c.TotalRecordsCountLabel';
import LBL_TOTAL_RECORDS_SELECTED_LABEL from '@salesforce/label/c.TotalRecordsSelectedLabel';
import LBL_NO_DATA_TITLE from '@salesforce/label/c.NoDataLoaded';
import LBL_FILL_REQUIRED_FIELDS_MESSAGE from '@salesforce/label/c.FillRequiredFieldsMessage';
import LBL_CREATE_NEW_RECORDS_BUTTON_TITLE from '@salesforce/label/c.CreateRecords';
import LBL_CLOSE_MODAL_WINDOW_TITLE from '@salesforce/label/c.CloseModalWindow';
import LBL_CANCEL_BUTTON_TITLE from '@salesforce/label/c.CancelButtonTitle';
import LBL_UNSUPPORTED_OBJECT_TYPE_ERROR_MESSAGE from '@salesforce/label/c.UnsupportedObjectType';
import LBL_RECORDS_CREATED_MESSAGE from '@salesforce/label/c.RecordSuccessfullyCreated';
import LBL_LOAD_PRODUCT_TYPES_ERROR_MESSAGE from '@salesforce/label/c.LoadingProductTypesError';
import LBL_NO_RECORDS from '@salesforce/label/c.NoRecordsFound';
import LBL_MAX_RECORDS_EXCEEDED from '@salesforce/label/c.MaxRecordsExceeded';
import LBL_ALL_ACCOUNTS_SELECTED from '@salesforce/label/c.AllAccountsSelected';
import LBL_ALL_ACCOUNTS_NOT_SELECTED from '@salesforce/label/c.AllAccountsNotSelected';

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
	allAccountsSelected = false;

	defaultSortDirection = 'asc';
	sortDirection = 'asc';
	sortedBy;

	comboBoxOptions = [
		{ label: 100, value: 100 },
		{ label: 200, value: 200 },
		{ label: 500, value: 500 },
		{ label: 1000, value: 1000 },
		{ label: 2000, value: 2000 }
	];

	pageNumber = 1;
	totalRecordsCount = 0;
	recordsPerPage = this.comboBoxOptions[0].value;

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
		LBL_CREATE_PMR_BUTTON_TITLE,
		LBL_CREATE_CAMPAIGN_MODAL_TITLE,
		LBL_RECORDS_PER_PAGE_TITLE,
		LBL_TOTAL_RECORDS_COUNT_LABEL,
		LBL_TOTAL_RECORDS_SELECTED_LABEL,
		LBL_NO_DATA_TITLE,
		LBL_NEXT_PAGE_BUTTON_TITLE,
		LBL_PREV_PAGE_TITLE,
		LBL_FILL_REQUIRED_FIELDS_MESSAGE,
		LBL_CREATE_NEW_RECORDS_BUTTON_TITLE,
		LBL_CLOSE_MODAL_WINDOW_TITLE,
		LBL_CANCEL_BUTTON_TITLE,
		LBL_ALL_ACCOUNTS_SELECTED,
		LBL_ALL_ACCOUNTS_NOT_SELECTED
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
			this.totalRecordsCount = 0;
			this.selectedUserHierarchy = [];
			this.selectedConfiguration = null;
			this.selectedProduct = newSelectProduct;
			this.selectedObjectType = newSelectObject;
			this.filterConditionList = [];
			this.sortedBy = null;
		}
	}

	get isTypeSelected() {
		return this.selectedConfiguration != null;
	}

	get totalRecordsSelected() {
		return this.selectedAccountIds.length;
	}

	handleUserHierarchySelectionChange(event) {
		this.selectedUserHierarchy = event.detail;
	}

	handleUpdateFilterConditions(event) {
		this.filterConditionList = event.detail.filterItems;
	}

	handleSelectConfiguration(event) {
		this.selectedConfiguration = event.detail;
		this.pageNumber = 1;
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
			(item) =>
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
			(item) =>
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

	addLookUpUrls(columns) {
		columns.forEach((obj) => {
			if (obj.fieldName.includes('Name')) {
				obj.type = 'url';
				obj.typeAttributes = {
					label: { fieldName: obj.fieldName },
					target: '_blank'
				};
				obj.fieldName = obj.fieldName.replace('Name', 'Url');
			}
		});
		return columns;
	}

	handleSubmitSearch() {
		if (this.isRequestNotValid) {
			this.errorToastMessage(LBL_INVALID_REQUEST_TITLE, LBL_INVALID_REQUEST_MESSAGE);
			return;
		}

		if (this.selectedObjectType === 'PortfolioManagementRequest__c') {
			const objType = 'PortfolioManagementRequest__c';
			const filterCond = 'Id != null';
			const fieldset = 'PortfolioManagementRequest';
			this.selectedConfiguration = {
				ObjectType__c: objType,
				FilterCondition__c: filterCond,
				FieldsetName__c: fieldset,
				OwnerFieldName__c: 'PortfolioMngmtA__c'
			};
		} else {
			this.addRecordTypeFilter();
		}
		this.addSelectedUsersToFilter();

		this.loading = true;

		const request = {
			filterItemList: this.filterConditionList,
			configuration: this.selectedConfiguration,
			objectName: this.selectedConfiguration.ObjectType__c,
			pageNumber: this.pageNumber,
			pageSize: this.recordsPerPage,
			sortBy: this.sortedBy,
			sortDirection: this.sortDirection
		};

		console.log('request: ' + JSON.stringify(request));
		const currentSelectedAccountIds = this.selectedAccountIds;
		countResults({ dto: request })
			.then((countResult) => {
				this.totalRecordsCount = countResult;
				const maxAllowedRecordsCount = 10000;
				if (countResult < 1) {
					this.toastMessage(null, '', LBL_NO_RECORDS);
					this.outputTableColumns = [];
					this.outputTableData = [];
					this.loading = false;
				} else if (countResult <= maxAllowedRecordsCount) {
					loadFieldsetDetail({
						fieldsetName: this.selectedConfiguration.FieldsetName__c,
						objectName: request.objectName
					})
						.then((colResponse) => {
							this.outputTableColumns = this.addLookUpUrls(colResponse);
							if (this.isTableVisible) {
								this.section = ['data'];
							} else {
								this.section = ['configuration'];
							}
						})
						.then(() => searchResults({ dto: request }))
						.then((response) => {
							this.totalRecordsCount = response.totalCount;

							if (this.totalRecordsCount < 1) {
								this.toastMessage(null, '', LBL_NO_RECORDS);
								return;
							}
							this.outputTableData = [];
							response.data.forEach((item) => {
								item.Url = '/lightning/r/' + item.Id + '/view';
								let objectKeys = Object.keys(item);
								objectKeys.forEach((key) => {
									const itemType = typeof item[key];
									if (itemType === 'object') {
										const newKey = key + '.Name';
										item[newKey] = item[key].Name;
										const urlKey = key + '.Url';
										item[urlKey] = '/lightning/r/' + item[key].Id + '/view';
									}
								});
								this.outputTableData.push(item);
							});
							this.selectedAccountIds = currentSelectedAccountIds;
							this.allAccountsSelected = this.totalRecordsCount === this.selectedAccountIds.length;
							if (this.allAccountsSelected) {
								this.selectedAccountIds = [];
							}
						})
						.catch((error) => {
							console.log(JSON.stringify(error));
							this.errorToastMessage('', error.body.message);
						})
						.finally(() => {
							this.loading = false;
						});
				} else {
					this.errorToastMessage('', LBL_MAX_RECORDS_EXCEEDED + ' ' + maxAllowedRecordsCount);
					this.loading = false;
				}
			})
			.catch((error) => {
				console.log(JSON.stringify(error));
				this.errorToastMessage('', error.body.message);
				this.loading = false;
			});
	}

	get isRequestNotValid() {
		if (this.selectedObjectType === 'PortfolioManagementRequest__c') {
			let hasCaseNumber = this.filterConditionList.find((element) => element.fieldName === 'Case__r.CaseNumber');
			let hasA = this.filterConditionList.find(
				(element) => element.fieldName === 'Case__r.Account.PortfolioMngmtA__r.CommissionAccountBase__c'
			);
			let hasC = this.filterConditionList.find(
				(element) => element.fieldName === 'Case__r.Account.PortfolioMngmtC__r.CommissionAccountBase__c'
			);
			if (hasCaseNumber || (hasA && hasC)) {
				return false;
			}
			return true;
		}
		return this.selectedConfiguration == null;
	}

	get isTableVisible() {
		return this.outputTableColumns.length > 0;
	}

	handleSelectAll() {
		if (this.allAccountsSelected) {
			this.selectedAccountIds = [];
			this.allAccountsSelected = false;
		} else {
			const request = {
				filterItemList: this.filterConditionList,
				configuration: this.selectedConfiguration,
				objectName: this.selectedConfiguration.ObjectType__c,
				pageNumber: this.pageNumber,
				pageSize: this.recordsPerPage,
				sortBy: this.sortedBy,
				sortDirection: this.sortDirection
			};

			getAllAccountId({ dto: request })
				.then((response) => {
					this.selectedAccountIds = response;
					this.allAccountsSelected = true;
				})
				.catch((error) => {
					console.log(JSON.stringify(error));
					this.errorToastMessage('', error.body.message);
				});
		}
	}

	errorToastMessage(title, message) {
		this.toastMessage('error', title, message, 'dismissable');
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
			this.selectedAccountIds = selectedRows.map((row) => row.Id);
			this.allAccountsSelected =
				this.selectedAccountIds.length === this.totalRecordsCount && this.totalRecordsCount !== 0;
		} else if (this.selectedConfiguration.ObjectType__c === 'Asset') {
			this.selectedAccountIds = selectedRows.map((row) => row.AccountId);
			this.allAccountsSelected =
				this.selectedAccountIds.length === this.totalRecordsCount && this.totalRecordsCount !== 0;
		} else if (this.selectedConfiguration.ObjectType__c === 'PortfolioManagementRequest__c') {
			this.selectedAccountIds = selectedRows.map((row) => row.Account__c);
			this.allAccountsSelected =
				this.selectedAccountIds.length === this.totalRecordsCount && this.totalRecordsCount !== 0;
		} else {
			this.errorToastMessage('', LBL_UNSUPPORTED_OBJECT_TYPE_ERROR_MESSAGE);
		}
	}

	get selectAllAccountsLabel() {
		return this.allAccountsSelected
			? this.labels.LBL_ALL_ACCOUNTS_SELECTED
			: this.labels.LBL_ALL_ACCOUNTS_NOT_SELECTED;
	}

	get selectAllAccountsIcon() {
		return this.allAccountsSelected ? 'utility:check' : 'utility:multi_select_checkbox';
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
			.catch((error) => {
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

	handleComboBoxChange(event) {
		this.recordsPerPage = event.detail.value;
		this.pageNumber = 1;
		this.handleSubmitSearch();
	}

	handlePageNextChange() {
		this.pageNumber++;
		this.handleSubmitSearch();
	}

	handlePagePrevChange() {
		this.pageNumber--;
		this.handleSubmitSearch();
	}

	get isPrevPageDisabled() {
		return this.pageNumber === 1;
	}

	get isNextPageDisabled() {
		return this.pageNumber === this.totalPageCount;
	}

	get totalPageCount() {
		return Math.ceil(this.totalRecordsCount / this.recordsPerPage);
	}

	get paginationInfo() {
		return this.pageNumber + ' / ' + this.totalPageCount;
	}

	onHandleSort(event) {
		const { fieldName: sortedBy, sortDirection } = event.detail;
		const request = {
			filterItemList: this.filterConditionList,
			configuration: this.selectedConfiguration,
			objectName: this.selectedConfiguration.ObjectType__c,
			pageNumber: this.pageNumber,
			pageSize: this.recordsPerPage,
			sortBy: sortedBy,
			sortDirection: sortDirection
		};

		searchResults({ dto: request }).then((response) => {
			this.totalRecordsCount = response.totalCount;

			if (this.totalRecordsCount < 1) {
				this.toastMessage(null, '', LBL_NO_RECORDS);
				return;
			}
			this.outputTableData = [];
			response.data.forEach((item) => {
				let objectKeys = Object.keys(item);
				objectKeys.forEach((key) => {
					const itemType = typeof item[key];
					if (itemType === 'object') {
						const newKey = key + '.Name';
						item[newKey] = item[key].Name;
					}
				});
				this.outputTableData.push(item);
			});

			const sortedByColumn = this.outputTableColumns.find((column) => {
				return column['fieldName'] === sortedBy;
			});
			const sortedByColumnType = 'type' in sortedByColumn ? sortedByColumn.type : null;

			if (sortedByColumnType !== 'DATE' && sortedByColumnType !== 'CURRENCY') {
				const cloneData = [...this.outputTableData];
				cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
				this.outputTableData = cloneData;
			}
			this.sortDirection = sortDirection;
			this.sortedBy = sortedBy;
		});
	}

	sortBy(field, reverse, primer) {
		const key = primer
			? function (x) {
					return primer(x[field]);
			  }
			: function (x) {
					return x[field];
			  };

		return function (a, b) {
			a = key(a);
			b = key(b);
			return reverse * ((a > b) - (b > a));
		};
	}
}
