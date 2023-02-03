global class AggregateResultIterable implements Iterable<AggregateResult> {
	private List<AggregateResult> aggrResult;

	global AggregateResultIterable(List<AggregateResult> aggrResult) {
		this.aggrResult = aggrResult;
	}

	global Iterator<AggregateResult> Iterator() {
		return new AggregateResultIterator(aggrResult);
	}
}
