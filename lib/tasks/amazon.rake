namespace :amazon do
  desc "Get categorys from amazon api"
  task getcategorys: :environment do
    
    requestd = Vacuum.new

    requestd.configure(
    aws_access_key_id: 'AKIAIAJR65JO6EIPQWTA',
    aws_secret_access_key: '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',
    associate_tag: 'microv'
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

    hashed_categories['BrowseNodeLookupResponse']['BrowseNodes']['BrowseNode']['Children']['BrowseNode'].each do |item|
      # update category if it's already exist.
      if Category.exists?(browse_node_id: item['BrowseNodeId'])
        category = Category.find_by_browse_node_id( item['BrowseNodeId'] )
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
    aws_access_key_id: 'AKIAIAJR65JO6EIPQWTA',
    aws_secret_access_key: '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',
    associate_tag: 'microv'
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
        # Check price exist.

        if defined? item['OfferSummary']['LowestNewPrice']['FormattedPrice']
          begin
          price = item['OfferSummary']['LowestNewPrice']['Amount'].to_i / 100.0
        rescue StandardError
          byebug
        end
        else
          byebug
          price = 0
        end

        # update product if it's already exist.
        if Product.exists?(asin: item['ASIN'])
          product = Product.find_by_asin( item['ASIN'] )
          product.update!(  
                            name: item['ItemAttributes']['Title'],
                            price: price,
                            url: item['DetailPageURL'],
                            feature: item['ItemAttributes']['Feature'],
                            image_url: item['LargeImage']['URL'],
                            link: item['ItemLinks']['ItemLink'][5]['URL'],
                            category_id: category.id
                            # asin: item['ASIN']
                          )
        else
          Product.create!(  
                            name: item['ItemAttributes']['Title'],
                            price: price,
                            url: item['DetailPageURL'],
                            feature: item['ItemAttributes']['Feature'],
                            image_url: item['LargeImage']['URL'],
                            link: item['ItemLinks']['ItemLink'][5]['URL'],
                            asin: item['ASIN'],
                            category_id: category.id,
                            active: true
                          )
        end
      end

    end

  end

end
