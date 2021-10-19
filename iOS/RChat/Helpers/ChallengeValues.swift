//
//  ChallengeValues.swift
//  RChat
//
//  Created by Andrew Morgan on 17/09/2021.
//

import Foundation

let boothMode = true
let userID = "6136422fa9e90969b55c40b8" // TODO: Could read this from the challenge app
let challengeAppID = "challenge-ydrbm"
let challengeUsername = "sql"
let challengePassword = "realmChallenge"
let userAppPrefix = "myrchat-"
let challengeConversation = Conversation(
    displayName: "Mrs DotNet",
    unreadCount: 0,
    members: [
        Member(userName: "sql", state: .active),
        Member(userName: "dotnet", state: .active)
    ])
