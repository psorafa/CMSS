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
		this(sObjectName, fields, false);
	}

	public ColumnDTOsBuilder(String sObjectName, List<String> fields, Boolean referenceAsButton) {
		for (String fieldWholeName : fields) {
			fieldWholeName = fieldWholeName.trim();

			String fieldName = fieldWholeName;
			String objName = sObjectName;

			List<String> lookupFieldDivision = fieldName.split('\\.');
			if (lookupFieldDivision.size() > 1) {
				objName = lookupFieldDivision[lookupFieldDivision.size() - 2].replace('__r', '__c');
				fieldName = lookupFieldDivision[lookupFieldDivision.size() - 1];
			}

			DescribeFieldResult descr = SchemaUtil.describeField(objName, fieldName);

			if (descr.getType() == DisplayType.REFERENCE) {
				if (referenceAsButton) {
					columns.add(buildButtonColumn(descr, fieldWholeName));
				} else {
					columns.add(buildLinkColumn(descr));
				}
			} else if (descr.getType() == DisplayType.DATE) {
				columns.add(buildDateColumn(descr));
			} else if (descr.getType() == DisplayType.DATETIME) {
				columns.add(buildDatetimeColumn(descr));
			} else if (descr.isNameField()) {
				if (referenceAsButton) {
					columns.add(buildButtonColumn(descr, fieldWholeName));
				} else {
					columns.add(buildSelfLinkColumn(descr));
				}
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
		col.typeAttributes.label.fieldName =
			relationshipName +
				'.' +
				SchemaUtil.getNameField(descr.getReferenceTo().get(0));
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

	private ColumnDTO buildButtonColumn(DescribeFieldResult descr, String fieldWholeName) {
		ColumnDTO col = new ColumnDTO();

		col.label = descr.getLabel();
		col.type = 'button';
		col.typeAttributes = new ColumnDTO.TypeAttributesDTO();
		col.typeAttributes.variant = 'base';
		col.typeAttributes.label = new ColumnDTO.LabelDTO();
		col.typeAttributes.label.fieldName = descr.getName() == fieldWholeName &&
			descr.getRelationshipName() != null
			? descr.getRelationshipName() + '.Name'
			: fieldWholeName;
		return col;
	}

	private String convertDisplayTypeToColumnType(DisplayType displayType) {
		if (typesConversionMap.containsKey(displayType)) {
			return typesConversionMap.get(displayType);
		}
		return 'text';
	}
}
