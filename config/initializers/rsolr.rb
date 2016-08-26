# ::ProductsSolrConnection = RSolr.connect :url => Settings.solr_config.solr_url
::ProductsSolrConnection = RSolr.connect url: 'http://localhost:8982/solr/development/'