public class DmlUtilMock extends DmlUtil {

	public List<DmlMockOperation> operations = new List<DmlUtilMock.DmlMockOperation>();
	public List<Id> idsToAssign;

	public override void insertData(List<SObject> data) {
		operations.add(new DmlMockOperation('insert', data));
		if (idsToAssign != null) {
			for (Integer i = 0; i < data.size(); i++) {
				SObject so = data.get(i);
				so.Id = idsToAssign.get(i);
			}
		}
	}
	public override void insertData(SObject data) {
		operations.add(new DmlMockOperation('insert', data));
		if (idsToAssign != null) {
			data.Id = idsToAssign.get(0);
		}
	}
	public override void updateData(List<SObject> data) {
		operations.add(new DmlMockOperation('update', data));
	}
	public override void updateData(SObject data) {
		operations.add(new DmlMockOperation('update', data));
	}
	public override void deleteData(List<SObject> data) {
		operations.add(new DmlMockOperation('delete', data));
	}
	public override void deleteData(SObject data) {
		operations.add(new DmlMockOperation('delete', data));
	}

	public class DmlMockOperation {
		public String type;
		public List<SObject> listData;
		public SObject singleRecord;

		public DmlMockOperation(String type, SObject data) {
			this.type = type;
			this.singleRecord = data;
		}

		public DmlMockOperation(String type, List<SObject> data) {
			this.type = type;
			this.listData = data;
		}
	}
}