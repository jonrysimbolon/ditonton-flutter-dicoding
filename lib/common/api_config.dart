const tmdbBaseUrl = String.fromEnvironment(
  'TMDB_BASE_URL',
  defaultValue: 'https://api.themoviedb.org/3',
);

const tmdbApiKey = String.fromEnvironment(
  'TMDB_API_KEY',
  defaultValue: '2174d146bb9c0eab47529b2e77d6b526',
);
