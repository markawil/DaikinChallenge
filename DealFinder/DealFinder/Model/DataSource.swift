//
//  DataSource.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/26/18.
//  Copyright © 2018 markw. All rights reserved.
//

import Foundation

struct Response : Decodable {
    
    let nextPage: String
    let items: [Item]
}

struct Item : Decodable {
    
    var name: String
    var shortDescription: String
    var longDescription: String
    var largeImage: String
    var thumbnailImage: String
    var salePrice: Double?
    var msrp: Double?
}

class DataSource {
    
    let walmartClient: FetchClient
    var lastResponseNextPage: String?
    
    let apiKey = "gz3qn6zut3aww5sep4xtrjzu";
    let baseUrlPath = "http://api.walmartlabs.com/"
    let firstPagePath = "v1/paginated/items?category=3944&count=10&apiKey=";
    
    init(client: FetchClient) {
        walmartClient = client
    }
    
    func itemsForNextPage(withCompletion completion: @escaping (_ items: [Item]?, _ errorMessage: String?) -> ()) {
        
        var urlPathToUse = baseUrlPath + firstPagePath + apiKey
        if let validNextPage = lastResponseNextPage {
            urlPathToUse = baseUrlPath + validNextPage
        }
        
        walmartClient.fetch(withUrlPath: urlPathToUse) { (data, errorMessage) in
            
            if let validData = data {
                
                if let validJSON = self.extractJSONTypeFromData(validData) as [String:AnyObject]? {
                    print(validJSON)
                }
                
                if let validResponse = self.response(fromData: validData) {
                    self.lastResponseNextPage = validResponse.nextPage
                    completion(validResponse.items, nil)
                } else {
                    completion(nil, "could not decode items from data")
                }
            } else if let validErrorMessage = errorMessage {
                completion(nil, validErrorMessage)
            } else {
                completion(nil, "something wen't wrong")
            }
        }
    }
    
    fileprivate func response(fromData data: Data) -> Response? {
        
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            return response
        }
        catch (let error) {
            print(error)
            return nil
        }
    }
    
    // for testing purposes
    fileprivate func extractJSONTypeFromData<T>(_ data: Data) -> T? {
        
        var json: T?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? T   }
        catch {
            print("error parsing the json")
        }
        
        return json
    }
    
    func stubbedItemsForTesting() -> [Item] {
        
        let itemDescription = "Our expensive headphones will make you look cool."
        let item1ImagePath = "https://i5.walmartimages.com/asr/77caef93-b437-42b6-bbd2-aa835f3be2cd_1.66e2ca95363abac5c860e3bcb9caedf0.jpeg"
        let item1 = Item(name: "Beats Solo 3 Blue", shortDescription: itemDescription, longDescription: itemDescription, largeImage: item1ImagePath, thumbnailImage:item1ImagePath , salePrice: 299.99, msrp: 299.99)
        let item2ImagePath = "https://i5.walmartimages.com/asr/9a83c205-c414-4f72-9fd6-e60f3b5aef75_1.d20515f7064acd0c5e74f10569212a67.jpeg"
        let item2 = Item(name: "Beats Solo 3 Red", shortDescription: itemDescription, longDescription: itemDescription, largeImage: item2ImagePath, thumbnailImage: item2ImagePath, salePrice: 299.99, msrp: 299.99)
        let item3ImagePath = "https://i5.walmartimages.com/asr/e8a074e7-fb06-46cb-8982-ea8fdb087c67_1.9ba79a4c7da2d39a67304b6b4dcc2355.jpeg"
        let item3 = Item(name: "Beats Solo 3 Silver", shortDescription: itemDescription, longDescription: itemDescription, largeImage: item3ImagePath, thumbnailImage: item3ImagePath, salePrice: 299.99, msrp: 299.99)
        let item4ImagePath = "https://i5.walmartimages.com/asr/bdad47f1-a8f4-4134-ae91-2b6239b682c7_1.6c055e8d557ed63249c4e8de8f6e9076.jpeg"
        let item4 = Item(name: "Beats Solo 3 Black", shortDescription: itemDescription, longDescription: itemDescription, largeImage: item4ImagePath, thumbnailImage: item4ImagePath, salePrice: 299.99, msrp: 299.99)
        
        return [item1, item2, item3, item4]
    }
}
