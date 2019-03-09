## Amazon - Alexa Web Information Service (AWIS)
Ruby Library for AWIS REST API - See: [Alexa Docs](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/)

### How to installation

```
gem install awis-sdk-ruby
```

### How to usage

##### Configure your amazon certificate

```
require 'awis'

AWIS_CONFIG = YAML.load(File.read('awis.yml'))
Awis.config do |c|
  c.access_key_id = AWIS_CONFIG['access_key_id']
  c.secret_access_key = AWIS_CONFIG['secret_access_key']
  c.debug = AWIS_CONFIG['debug']
  c.protocol = 'https'    # Default 'https'
  c.timeout = 10          # Default 10
  c.open_timeout = 10     # Default 10
  c.logger = false        # Default nil
end
```

##### Get UrlInfo Information

``` ruby
client = Awis::Client.new
url_info = client.url_info(url: "site.com")
```

If you looking for the API request URI:

* Awis::API::UrlInfo.new.load_request_uri(url: 'site.com')


Returns object that contains attributes:

* data_url
* rank
* asin
* xml

Returns object that contains relationships:

* contact_info [:data_url, :owner_name, :email, :physical_address, :company_stock_ticker, :phone_numbers]
* content_data [:data_url, :site_title, :site_description, :speed_median_load_time, :speed_percentile, :adult_content, :language_locale, :links_in_count, :owned_domains]
* usage_statistics [:time_range_months, :time_range_days, :rank_value, :rank_delta, :reach_rank_value, :reach_rank_delta,
                    :reach_per_million_value, :reach_per_million_delta, :reach_page_views_per_million_value, :reach_page_views_per_million_delta,
                    :reach_page_views_rank_value, :reach_page_views_rank_delta, :reach_page_views_per_user_value, :reach_page_views_per_user_delta]
    - add two methods: [range_type, range_count]
* related_links [:data_url, :navigable_url, :title]
* categories [:title, :absolute_path]

New methods:

* is_404?

You can specify options:

* url
* response_group - which data to include in response (i.e. ["rank", "contact_info", "content_data"]) - defaults to all available

##### Get Sites Linking In

``` ruby
client = Awis::Client.new
sites_linking_in = client.sites_linking_in(url: "site.com")
```

If you looking for the API request URI:

* Awis::API::SitesLinkingIn.new.load_request_uri(url: 'site.com')

Returns object that contains relationships:

* sites [:title, :url]

You can specify options:

* url
* count - how many results to retrieve - defaults to max value that is 20
* start - offset of results - defaults to 0

##### Get Traffic History

``` ruby
client = Awis::Client.new
traffic_history = client.traffic_history(url: "site.com")
```

If you looking for the API request URI:

* Awis::API::TrafficHistory.new.load_request_uri(url: 'site.com')

Returns object that contains methods:

* range
* site
* start

Returns object that contains relationships:

* historical_data [:date, :page_views_per_million, :page_views_per_user, :rank, :reach_per_million]

You can specify options:

* url
* range - how many days to retrieve - defaults to max value 31
* start - start date (i.e. "20120120", 4.days.ago) - defaults to range number days ago

##### Get Category Listings

``` ruby
client = Awis::Client.new
category_listings = client.category_listings(path: "Top/Arts")
```

If you looking for the API request URI:

* Awis::API::CategoryListings.new.load_request_uri(path: "Top/Games/Card_Games")

Returns object that contains methods:

* count
* recursive_count

Returns object that contains relationships:

* listings [:data_url, :title, :popularity_rank, :description]

##### Get Category Browse

``` ruby
client = Awis::Client.new
category_browses = client.category_browse(path: "Top/Arts")
```

If you looking for the API request URI:

* Awis::API::CategoryBrowse.new.load_request_uri(path: "Top/Games/Card_Games")

Returns object that contains methods:

* categories [:path, :title, :sub_category_count, :total_listing_count]
* language_categories [:path, :title, :sub_category_count, :total_listing_count]
* related_categories [:path, :title, :sub_category_count, :total_listing_count]
* letter_bars [:path, :title, :sub_category_count, :total_listing_count]

Returns object that contains relationships:

* listings [:data_url, :title, :popularity_rank, :description]

##### How to run test

* bundle exec rake test

##### Request ID and Status Code

You can retrieve status code and requestID

* request_id
* status_code

### Parsers

Awis is using `nokogiri` to parse XML documents.

### Contributors

* [Encore Shao](https://github.com/encoreshao)

### Copyright

Copyright (c) Encore Shao. See LICENSE for details.
