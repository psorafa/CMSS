import LightningDatatable from 'lightning/datatable';
import imageTemplate from './tableImageTemplate.html';

export default class DataTableWithImage extends LightningDatatable {
	imageFields = [];

	static customTypes = {
		image: {
			template: imageTemplate,
			standardCellLayout: true
		}
	};

	connectedCallback() {
		this.scanForImageData();
		this.updateImageColumns();
	}

	scanForImageData() {
		var textColumns = this.columns.filter((column) => column.type === 'text').map((column) => column.fieldName);

		this.data = this.data.map((fieldData) => {
			var updatedField = {
				...fieldData
			};
			textColumns.forEach((columnName) => {
				if (fieldData[columnName]?.startsWith('<img')) {
					let imageUrlValue = fieldData[columnName]
						.replace('<img ', '')
						.split(' ')
						.filter((item) => item.includes('src'))[0];
					imageUrlValue = imageUrlValue.split('"')[1];
					if (!this.imageFields.includes(columnName)) {
						this.imageFields.push(columnName);
					}
					updatedField[columnName] = imageUrlValue;
				} else {
					if (fieldData[columnName] && fieldData[columnName]?.lenght > 0) {
						textColumns.splice(textColumns.indexOf(columnName), 1);
					}
				}
			});
			return updatedField;
		});
	}

	updateImageColumns() {
		this.columns = this.columns.map((column) => {
			var updatedColumn = { ...column };
			if (this.imageFields.includes(column?.fieldName)) {
				updatedColumn['type'] = 'image';
			}
			return updatedColumn;
		});
	}
}
