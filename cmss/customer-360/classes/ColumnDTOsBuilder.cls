public class ColumnDTOsBuilder {
	private static final Map<DisplayType, String> typesConversionMap = new Map<DisplayType, String>{
		DisplayType.DATE => 'date-local',
		DisplayType.DATETIME => 'date',
		DisplayType.DOUBLE => 'number',
		DisplayType.INTEGER => 'number',
		DisplayType.CURRENCY => 'currency',
		DisplayType.BOOLEAN => 'boolean'
	};

	private List<ColumnDTO> columns = new List<ColumnDTO>();

	public ColumnDTOsBuilder(String sObjectName, List<String> fields) {
		for (String fieldName : fields) {
			fieldName = fieldName.trim();
			DescribeFieldResult descr = SchemaUtil.describeField(sObjectName, fieldName);
			if (descr.getType() == DisplayType.REFERENCE) {
				columns.add(buildLinkColumn(descr));
			} else if (descr.getType() == DisplayType.DATE) {
				columns.add(buildDateColumn(descr));
			} else if (descr.getType() == DisplayType.DATETIME) {
				columns.add(buildDatetimeColumn(descr));
			} else if (descr.isNameField()) {
				columns.add(buildSelfLinkColumn(descr));
			} else {
				columns.add(buildColumn(descr));
			}
		}
	}

	public List<ColumnDTO> getColumnDTOs() {
		return columns;
	}

	private ColumnDTO buildSelfLinkColumn(DescribeFieldResult descr) {
		ColumnDTO col = new ColumnDTO();
		col.fieldName = 'Link';
		col.label = descr.getLabel();
		col.type = 'url';
		col.sortable = false;
		col.hideDefaultActions = true;
		col.typeAttributes = new ColumnDTO.TypeAttributesDTO();
		col.typeAttributes.label = new ColumnDTO.LabelDTO();
		col.typeAttributes.label.fieldName = descr.getName();
		return col;
	}

	private ColumnDTO buildLinkColumn(DescribeFieldResult descr) {
		String relationshipName = descr.getRelationshipName();
		ColumnDTO col = new ColumnDTO();
		col.fieldName = relationshipName + '.Link';
		col.label = descr.getLabel();
		col.type = 'url';
		col.sortable = false;
		col.hideDefaultActions = true;
		col.typeAttributes = new ColumnDTO.TypeAttributesDTO();
		col.typeAttributes.label = new ColumnDTO.LabelDTO();
		col.typeAttributes.label.fieldName = relationshipName + '.' + SchemaUtil.getNameField(descr.getReferenceTo().get(0));
		return col;
	}

	private ColumnDTO buildColumn(DescribeFieldResult descr) {
		ColumnDTO col = new ColumnDTO();
		col.fieldName = descr.getName();
		col.label = descr.getLabel();
		col.type = convertDisplayTypeToColumnType(descr.getType());
		col.sortable = false;
		col.hideDefaultActions = true;
		return col;
	}

	private ColumnDTO buildDateColumn(DescribeFieldResult descr) {
		ColumnDTO col = buildColumn(descr);
		col.typeAttributes = new ColumnDTO.TypeAttributesDTO();
		col.typeAttributes.day = '2-digit';
		col.typeAttributes.month = '2-digit';
		col.typeAttributes.year = 'numeric';
		return col;
	}

	private ColumnDTO buildDatetimeColumn(DescribeFieldResult descr) {
		ColumnDTO col = buildDateColumn(descr);
		col.typeAttributes.minute = '2-digit';
		col.typeAttributes.hour = '2-digit';
		return col;
	}

	private String convertDisplayTypeToColumnType(DisplayType displayType) {
		if (typesConversionMap.containsKey(displayType)) {
			return typesConversionMap.get(displayType);
		}
		return 'text';
	}


}
