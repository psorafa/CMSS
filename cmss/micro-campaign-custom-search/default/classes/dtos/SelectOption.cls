public class SelectOption {
	@AuraEnabled
	public String label { get; set; }
	@AuraEnabled
	public String value { get; set; }

	public SelectOption(String label, String value) {
		this.label = label;
		this.value = value;
	}

	public SelectOption(String label) {
		this.label = label;
		this.value = label;
	}
}
