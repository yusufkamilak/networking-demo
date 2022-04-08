//
//  PostItem.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

struct PostItem: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
