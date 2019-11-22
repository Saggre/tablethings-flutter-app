/// Whether information has been fetched from the database. If not, the class may only contain an Id
enum FetchState { notFetched, fetched }

/// Wrapper for a data class to easily update a blocbuilders pre- and post-database fetches
class FetchablePackage<T, U> {
  T _id;
  U _data;
  FetchState fetchState;

  FetchablePackage(id) {
    fetchState = FetchState.notFetched;
    _data = null;
    _id = id;
  }

  void setFetchedData(U data) {
    _data = data;
    fetchState = FetchState.fetched;
  }

  T getFetchId() {
    return _id;
  }

  U getData() {
    return _data;
  }
}
