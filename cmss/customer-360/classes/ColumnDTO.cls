public class ColumnDTO {
	@AuraEnabled public String label;
	@AuraEnabled public String fieldName;
	@AuraEnabled public Boolean sortable;
	@AuraEnabled public String type;
	@AuraEnabled public Boolean hideDefaultActions;
	@AuraEnabled public ColumnDTO.TypeAttributesDTO typeAttributes;

	public class TypeAttributesDTO {
		@AuraEnabled public ColumnDTO.LabelDTO label;
		@AuraEnabled public ColumnDTO.RowActionsDTO rowActions;
		@AuraEnabled public String target;
		@AuraEnabled public String tooltip;
		@AuraEnabled public String day;
		@AuraEnabled public String month;
		@AuraEnabled public String year;
		@AuraEnabled public String hour;
		@AuraEnabled public String minute;
	}

	public class LabelDTO {
		@AuraEnabled public String fieldName;
	}

	public class RowActionsDTO {
		@AuraEnabled public String label;
		@AuraEnabled public String name;
	}
}
