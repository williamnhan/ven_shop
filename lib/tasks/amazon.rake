namespace :amazon do
  desc "Get categorys from amazon api"
  task getcategorys: :environment do
    
    requestd = Vacuum.new

    requestd.configure(
    aws_access_key_id: Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    associate_tag: Rails.application.secrets.associate_tag
    )

    # Root node from amazon
    # http://docs.aws.amazon.com/AWSECommerceService/latest/DG/LocaleUS.html
    # Get catagory from HomeGarden id=1063498
    response = requestd.browse_node_lookup(
      query: {
        'BrowseNodeId' => 1063498 # Node name: HomeGarden
      }
    )
    hashed_categories = response.to_h
    # print hashed_categories
    # Process.exit!(true)
    hashed_categories['BrowseNodeLookupResponse']['BrowseNodes']['BrowseNode']['Children']['BrowseNode'].each do |item|
      # update category if it's already exist.
      category = Category.find_by( browse_node_id: item['BrowseNodeId'] )
      if category        
        category.update!(name: item['Name'])
      else 
        Category.create!( name: item['Name'], 
                        browse_node_id: item['BrowseNodeId'], 
                        active: true
                      )
      end
    end
  end

  desc "Get 20 items from each category"
  task getitems: :environment do
    requestd = Vacuum.new

    requestd.configure(
    aws_access_key_id: Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    associate_tag: Rails.application.secrets.associate_tag
    )

    categories = Category.all
    categories.each do |category| 

      response = requestd.item_search(
        query: {
          'SearchIndex' => 'HomeGarden',  # Root node from amazon US locate.
          'BrowseNode' => category.browse_node_id,       # Subnode from root node.
          # 'Keywords' => 'Architecture'
          'ResponseGroup' => "ItemAttributes,Offers,Images"
        }
      )
      hashed_products = response.to_h
      hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
        price = item.dig( "OfferSummary", 'LowestNewPrice', 'Amount' ).to_i / 100.0

        product = Product.find_or_initialize_by(asin: item["ASIN"])
        product.update!(  
          name: item['ItemAttributes']['Title'],
          price: price,
          url: item['DetailPageURL'],
          feature: item['ItemAttributes']['Feature'],
          image_url: (item['LargeImage'] ? item['LargeImage']['URL'] : ''),
          link: item['ItemLinks']['ItemLink'][5]['URL'],
          category_id: category.id
          # asin: item['ASIN']
        )
      end

    end

  end

end
