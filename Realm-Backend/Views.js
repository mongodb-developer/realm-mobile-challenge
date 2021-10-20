use RChat
db.createView('viewMessagesByRoom', 'ChatMessage', [{$match: {
  author: "room"
}}, {$project: {
  _id:0,
  timestamp: 1,
  messageComponents: {
    $split: ["$text", " - "]
  }
}}, {$project: {
  timestamp: 1,
  room: {$arrayElemAt: ["$messageComponents", 0]},
  action: {$arrayElemAt: ["$messageComponents", 1]},
  suspect: {$arrayElemAt: ["$messageComponents", 2]}
}}, {$sort: {
  timestamp: 1
}}, {$group: {
  _id: "$room",
  activity: {
    $push: {suspect: "$suspect", action: "$action", timestamp: "$timestamp"}
  }
}}, {$project: {
  _id: 0,
  room: "$_id",
  activity: 1
}}])

db.createView('viewRoomsBySuspect', 'ChatMessage', [
    {
      $match: {
        author: "room"
      }
    },
    {
      $project: {
        _id: 0,
        timestamp: 1,
        messageComponents: {
          $split: [
            "$text",
            " - "
          ]
        }
      }
    },
    {
      $project: {
        timestamp: 1,
        room: {$arrayElemAt: ["$messageComponents",0]},
        action: {$arrayElemAt: ["$messageComponents", 1]},
        suspect: {$arrayElemAt: ["$messageComponents", 2]
        }
      }
    },
    {
      $sort: {
        "timestamp": 1
        }
    },
    {
      $group: {
        _id: "$suspect",
        "activity": {
          $push: {room: "$room", action: "$action", timestamp: "$timestamp"}
        }
      }
    },
    {
      $project: {
        _id: 0,
        suspect: "$_id",
        activity: 1
      }
    }
  ]
)

db.createView('viewMessagesBySuspect', 'ChatMessage', [
{$match: {
  author: {$ne: "room"}
}}, {$sort: {
  timestamp: 1
}}, {$project: {
  _id: 0,
  author: 1,
  text: 1,
  timestamp: 1
}}, {$group: {
  _id: "$author",
  count: {$sum: 1},
  messages: {
    $push: {
      text: "$text",
      timestamp: "$timestamp"
    }
  }
}}, {$project: {
  _id: 0,
  author: "$_id",
  count: 1,
  messages: 1
}}])