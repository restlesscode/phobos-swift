//
//
//  PBSGhostPostResponseModel.swift
//  PhobosSwiftUIComponent
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public struct PBSGhostPostResponse: Codable {
  public let posts: [Post]
  public let meta: Meta
}

extension PBSGhostPostResponse {
  public struct Post: Codable {
    public let id: String
    public let uuid: String
    public let title: String
    public let slug: String
    public let html: String
    public let commentId: String
    public let featureImage: URL?
    public let featured: Bool?
    public let page: Bool?
    // Meta Data
    public let metaTitle: String?
    public let metaDescription: String?
    public let canonicalUrl: URL?
    // Twitter Card
    public let twitterImage: URL?
    public let twitterTitle: String?
    public let twitterDescription: String?
    // Code Injection
    public let codeinjectionHead: String?
    public let codeinjectionFoot: String?

    public let createdAt: String
    public let updatedAt: String
    public let publishedAt: String

    public let primaryTag: Tag?
    public let excerpt: String
    public let customExcerpt: String?

    public let ogImage: URL?
    public let ogTitle: String?
    public let ogDescription: String?

    public let customTemplate: String?
    public let primaryAuthor: Author?
    public let url: URL
    public let tags: [Tag]?
    public let authors: [Author]?

    enum CodingKeys: String, CodingKey {
      case id
      case uuid
      case title
      case slug
      case html
      case commentId = "comment_id"
      case featureImage = "feature_image"
      case featured
      case page
      case metaTitle = "meta_title"
      case metaDescription = "meta_description"
      case canonicalUrl = "canonical_url"

      case twitterImage = "twitter_image"
      case twitterTitle = "twitter_title"
      case twitterDescription = "twitter_description"

      case codeinjectionHead = "codeinjection_head"
      case codeinjectionFoot = "codeinjection_foot"

      case createdAt = "created_at"
      case updatedAt = "updated_at"
      case publishedAt = "published_at"

      case primaryTag = "primary_tag"
      case excerpt
      case customExcerpt = "custom_excerpt"

      case ogImage = "og_image"
      case ogTitle = "og_title"
      case ogDescription = "og_description"

      case customTemplate = "custom_template"
      case primaryAuthor = "primary_author"
      case url
      case tags
      case authors
    }
  }

  public struct Meta: Codable {
    let pagination: Pagination
  }
}

extension PBSGhostPostResponse.Meta {
  public struct Pagination: Codable {
    let page: Int
    let limit: Int
    let pages: Int
    let total: Int
  }
}

extension PBSGhostPostResponse {
  public struct Author: Codable {
    public let id: String
    public let name: String
    public let slug: String
    public let profileImage: URL
    public let coverImage: URL?
    public let bio: String?
    public let website: String?
    public let location: String?
    public let facebook: String?
    public let twitter: String?
    public let metaTitle: String?
    public let metaDescription: String?
    public let url: URL

    enum CodingKeys: String, CodingKey {
      case id
      case name
      case slug
      case profileImage = "profile_image"
      case coverImage = "cover_image"
      case bio
      case website
      case location
      case facebook
      case twitter
      case metaTitle = "meta_title"
      case metaDescription = "meta_description"
      case url
    }
  }

  public struct Tag: Codable {
    public let id: String
    public let name: String
    public let slug: String
    public let description: String?
    public let featureImage: URL?
    public let visibility: String
    public let metaTitle: String?
    public let metaDescription: String?
    public let url: URL

    enum CodingKeys: String, CodingKey {
      case id
      case name
      case slug
      case description
      case featureImage = "feature_image"
      case visibility
      case metaTitle = "meta_title"
      case metaDescription = "meta_description"
      case url
    }
  }
}
