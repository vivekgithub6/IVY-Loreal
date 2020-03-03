global class AggregateResultIterable implements Iterable<AggregateResult> {
  private String query;

  global AggregateResultIterable(String soql){
    query = soql;
      system.debug('query'+query);
  }

  global Iterator<AggregateResult> Iterator(){
    return new AggregateResultIterator(query);
  }
}