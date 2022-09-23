import { LightningElement, wire } from 'lwc';
import loadUserHierarchyTree from '@salesforce/apex/CustomSearchController.loadUserHierarchyTree';
import LBL_AGENT_ACTIVITY_TYPE from '@salesforce/label/c.AgentActivityType';
import LBL_NAME_AND_SURNAME from '@salesforce/label/c.NameAndSurname';
import LBL_UserHierarchyFilter from '@salesforce/label/c.UserHierarchyFilter';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export const COLUMNS = [
	{
		type: 'text',
		fieldName: 'name',
		label: LBL_NAME_AND_SURNAME,
		sortable: false
	},
	{
		type: 'text',
		fieldName: 'functionType',
		label: LBL_AGENT_ACTIVITY_TYPE,
		sortable: false
	}
];

export default class UserHierarchyTreeComponent extends LightningElement {
	gridColumns = COLUMNS;

	gridData;
	expandedRows = [];
	loading = true;
	selectedRows = [];

	labels = { LBL_UserHierarchyFilter };

	@wire(loadUserHierarchyTree)
	wiredUserHierarchyTree({ error, data }) {
		if (data) {
			this.gridData = JSON.parse(
				JSON.stringify(data)
					.split('children')
					.join('_children')
			);
			this.expandedRows = this.getUserIdList(this.gridData[0]);
			this.loading = false;
		} else if (error) {
			this.errorToastMessage('Error', error.body.message);
			this.loading = false;
		}
	}

	getUserIdList(row) {
		let userIdList = [];
		if (row.userId) {
			userIdList.push(row.userId);
		}
		if (row._children) {
			row._children.forEach(child => {
				userIdList = userIdList.concat(this.getUserIdList(child));
			});
		}
		return userIdList;
	}

	errorToastMessage(title, message) {
		this.toastMessage('error', title, message);
	}

	toastMessage(variant, title, message) {
		const evt = new ShowToastEvent({
			variant: variant,
			title: title,
			message: message,
			mode: 'sticky'
		});
		this.dispatchEvent(evt);
	}

	updateSelectedRows() {
		let currentSelectRows = this.template.querySelector('lightning-tree-grid').getSelectedRows();

		if (currentSelectRows.length - this.selectedRows.length > 1) {
			this.selectedRows = currentSelectRows.map(row => row.userId);
		} else if (currentSelectRows.length > this.selectedRows.length) {
			let selectedRowId = null;
			let currentSelectedUserId = currentSelectRows.map(row => row.userId);
			currentSelectedUserId.forEach(userId => {
				if (!this.selectedRows.includes(userId)) {
					selectedRowId = userId;
				}
			});

			this.gridData.forEach(record => {
				let items = this.selectAllChildRecords(record, selectedRowId, false);
				this.selectedRows = this.selectedRows.concat(items);
			});
		} else {
			this.selectedRows = currentSelectRows.map(row => row.userId);
		}

		this.fireSelectedRows();
	}

	selectAllChildRecords(row, selectedUserId, selectAllChilds) {
		const selectedUserIdList = [];
		if (selectedUserId === row.userId || selectAllChilds) {
			selectedUserIdList.push(row.userId);
			selectAllChilds = true;
		}

		if (row._children) {
			row._children.forEach(child => {
				let items = this.selectAllChildRecords(child, selectedUserId, selectAllChilds);
				items.forEach(item => {
					selectedUserIdList.push(item);
				});
			});
		}

		return selectedUserIdList;
	}

	rowDataCount(dataRow) {
		let count = 0;
		if (dataRow._children.length > 0) {
			dataRow._children.forEach(child => {
				count += this.rowDataCount(child);
			});
		}
		return count + 1;
	}

	fireSelectedRows() {
		const selectedRowsToEvent = [];
		this.selectedRows.forEach(userId => {
			const clearUserId = userId.replaceAll('_copy', '');
			if (!selectedRowsToEvent.includes(clearUserId)) {
				selectedRowsToEvent.push(clearUserId);
			}
		});
		const selectEvent = new CustomEvent('userhierarchyselection', { detail: selectedRowsToEvent });
		this.dispatchEvent(selectEvent);
	}
}
