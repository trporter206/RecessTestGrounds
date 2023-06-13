//
//  TestData.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class TestData: ObservableObject {
    @Published var users = usersData
    @Published var clubs = clubsData
    @Published var activities: [Activity] = []
    @Published var currentUser = usersData[0]
    @Published var loggedIn = false
    
    let activitiesRef = Firestore.firestore().collection("Activities")
    
    static let previewTestData = TestData(skipFetching: true)
    
    init(skipFetching: Bool = false) {
        if !skipFetching {
            getActivities()
        }
        print(mapLocations.count)
    }
    
    func getActivities() {
        activities = []
        activitiesRef.getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting activity documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let activity = try document.data(as: Activity.self)
                        //delete activity if it is older than 24 hours, else add to list
                        if Date.now.timeIntervalSince(activity.date) > 86400 {
                            self.activitiesRef.document(activity.id).delete()
                        } else {
                            self.activities.append(activity)
                        }
                    } catch {
                        print("Error decoding activity documents: \(error)")
                    }
                }
            }
        }
    }
}




var usersData: [User] = [
    User(name: "Temp User", email: "test@email.com", avatar: "3d_avatar_1")
]

var activitiesData: [Activity] = [
    Activity(title: "Blacktop basketball",
             sport: "Basketball",
             date: Date.now,
             description: "Casual game downtown. Come join the crew!",
             coordinates: [45.568978, -122.673523],
             creator: usersData[0].id)
]

var clubsData: [Club] = [
    Club(id: UUID().uuidString,
         creator: usersData[0].id,
         name: "Portland Blacktop",
         sport: "Basketball",
         members: [usersData[0].id],
         numActivities: 12,
         type: "Paid",
         description: "For Portlanders who are serious weekend warriors looking to improve their game")
]

var avatarStrings: [String] = [
    "3d_avatar_1",
    "3d_avatar_3",
    "3d_avatar_6",
    "3d_avatar_7",
    "3d_avatar_8",
    "3d_avatar_9",
    "3d_avatar_10",
    "3d_avatar_11",
    "3d_avatar_12",
    "3d_avatar_13",
    "3d_avatar_15",
    "3d_avatar_16",
    "3d_avatar_17",
    "3d_avatar_18",
    "3d_avatar_19",
    "3d_avatar_20",
    "3d_avatar_21",
    "3d_avatar_23",
    "3d_avatar_24",
    "3d_avatar_25",
    "3d_avatar_26",
    "3d_avatar_27",
    "3d_avatar_28",
    "3d_avatar_29",
    "3d_avatar_30",
]

var sportOptions: [String] = [
    "Baseball",
    "Basketball",
    "Football",
    "Rugby",
    "Soccer",
    "Spikeball",
    "Tennis",
    "Volleyball",
    "Other"
]

var mapLocations: [Location] = [
    Location(sport: "Basketball", coordinates: [45.569186, -122.672717], notes: "2 small courts", address: "Peninsula Park"),
    Location(sport: "Basketball", coordinates: [45.526198, -122.678870], notes: "2 half courts", address: "North Park Blocks 400–518 NW Park Ave Portland, OR  97209 United States"),
    Location(sport: "Tennis", coordinates: [45.546163, -122.657970], notes: "4 courts, lights are turned off at 9:30 PM, October 1-May 31, and at 10:00 PM, June 1-September 30.", address: "NE 7th Avenue and Fremont Street Portland, OR 97212"),
    Location(sport: "Basktball", coordinates: [45.547805, -122.657797], notes: "2 courts", address: "NE 7th Avenue and Fremont Street Portland, OR 97212"),
    Location(sport: "Basktball", coordinates: [45.547805, -122.657797], notes: "2 courts", address: "NE 7th Avenue and Fremont Street Portland, OR 97212"),
    Location(sport: "Volleyball", coordinates: [45.547128, -122.656774], notes: "", address: "NE 7th Avenue and Fremont Street Portland, OR 97212"),
    Location(sport: "Soccer", coordinates: [45.547128, -122.656774], notes: "2 possible pitches", address: "NE 7th Avenue and Fremont Street Portland, OR 97212"),
    Location(sport: "Baseball", coordinates: [45.547128, -122.656774], notes: "3 fields", address: "NE 7th Avenue and Fremont Street Portland, OR 97212"),
    Location(sport: "Tennis", coordinates: [45.569395, -122.672729], notes: "2 Tennis court lights are turned off at 10:00 PM. Park hours: 5:00am-midnight.", address: "700 N Rosa Parks Way Portland, OR 97217"),
    Location(sport: "Basketball", coordinates: [45.569149, -122.672733], notes: "Park hours: 5:00am-midnight.", address: "700 N Rosa Parks Way Portland, OR 97217"),
    Location(sport: "Soccer", coordinates: [45.568305, -122.673440], notes: "Park hours: 5:00am-midnight.", address: "700 N Rosa Parks Way Portland, OR 97217"),
    Location(sport: "Soccer", coordinates: [45.568305, -122.673440], notes: "Park hours: 5:00am-midnight.", address: "700 N Rosa Parks Way Portland, OR 97217"),
    Location(sport: "Baseball", coordinates: [45.568305, -122.673440], notes: "Park hours: 5:00am-midnight.", address: "700 N Rosa Parks Way Portland, OR 97217"),
    Location(sport: "Tennis", coordinates: [45.519435, -122.706521], notes: "4 courts. Park hours: 5:00 am - 10:00 pm Closed to vehicles at 10:00 pm. To reserve a sports field, picnic area, or amphitheater, please call 503-823-2525.", address: "400 SW Kingston Avenue Portland, OR 97210"),
    Location(sport: "Soccer", coordinates: [45.519435, -122.706521], notes: "1 field. Park hours: 5:00 am - 10:00 pm Closed to vehicles at 10:00 pm. To reserve a sports field, picnic area, or amphitheater, please call 503-823-2525.", address: "400 SW Kingston Avenue Portland, OR 97210"),
    Location(sport: "Soccer", coordinates: [45.519815, -122.623816], notes: "Short field. Park hours: 5:00am-10:30pm", address: "SE Cesar E Chavez Blvd and Stark Street Portland, OR 97214"),
    Location(sport: "Basketball", coordinates: [45.519487, -122.623438], notes: "1 full court, 2 half courts. Park hours: 5:00am-10:30pm", address: "SE Cesar E Chavez Blvd and Stark Street Portland, OR 97214"),
    Location(sport: "Tennis", coordinates: [45.519956, -122.625452], notes: "2 lighted courts. Park hours: 5:00am-10:30pm", address: "SE Cesar E Chavez Blvd and Stark Street Portland, OR 97214"),
    Location(sport: "Volleyball", coordinates: [45.519452, -122.624973], notes: "Park hours: 5:00am-10:30pm", address: "SE Cesar E Chavez Blvd and Stark Street Portland, OR 97214"),
    Location(sport: "Basketball", coordinates: [45.572109, -122.653881], notes: "1 court. Park hours: 5:00am-midnight", address: "NE 13th Avenue and Dekum Street Portland, OR 97211"),
    Location(sport: "Soccer", coordinates: [45.573418, -122.652937], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "NE 13th Avenue and Dekum Street Portland, OR 97211"),
    Location(sport: "Baseball", coordinates: [45.573418, -122.652937], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "NE 13th Avenue and Dekum Street Portland, OR 97211"),
    Location(sport: "Baseball", coordinates: [45.565481, -122.645082], notes: "2 fields. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "NE 22nd Avenue and Killingsworth Street Portland, OR 97211"),
    Location(sport: "Soccer", coordinates: [45.565481, -122.645082], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "NE 22nd Avenue and Killingsworth Street Portland, OR 97211"),
    Location(sport: "Basketball", coordinates: [45.563736, -122.644912], notes: "1 covered court. Park hours: 5:00am-midnight.", address: "NE 22nd Avenue and Killingsworth Street Portland, OR 97211"),
    Location(sport: "Tennis", coordinates: [45.563596, -122.645790], notes: "1 court. Park hours: 5:00am-midnight.", address: "NE 22nd Avenue and Killingsworth Street Portland, OR 97211"),
    Location(sport: "Soccer", coordinates: [45.572400, -122.693473], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Bryant Street and Delaware Avenue Portland, OR 97217"),
    Location(sport: "Baseball", coordinates: [45.572400, -122.693473], notes: "2 fields. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Bryant Street and Delaware Avenue Portland, OR 97217"),
    Location(sport: "Tennis", coordinates: [45.573213, -122.693713], notes: "2 lighted courts. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Bryant Street and Delaware Avenue Portland, OR 97217"),
    Location(sport: "Soccer", coordinates: [45.552234, -122.518397], notes: "1 field. Park hours: 5:00am-midnight. No parking on park side of street after 10:00pm. To reserve a sports field, call 503-823-2525.", address: "NE 141st Avenue and Failing Street Portland, OR 97230"),
    Location(sport: "Baseball", coordinates: [45.552234, -122.518397], notes: "Park hours: 5:00am-midnight. No parking on park side of street after 10:00pm. To reserve a sports field, call 503-823-2525.", address: "NE 141st Avenue and Failing Street Portland, OR 97230"),
    Location(sport: "Basketball", coordinates: [45.551535, -122.519229], notes: "1 full court, 1 half court. Park hours: 5:00am-midnight. No parking on park side of street after 10:00pm", address: "NE 141st Avenue and Failing Street Portland, OR 97230"),
    Location(sport: "Tennis", coordinates: [45.551535, -122.519229], notes: "4 lighted courts. Park hours: 5:00am-midnight. No parking on park side of street after 10:00pm.", address: "NE 141st Avenue and Failing Street Portland, OR 97230"),
    Location(sport: "Baseball", coordinates: [45.473373, -122.623280], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, please call 503-823-2525.", address: "3701 SE Bybee Blvd Portland, OR 97202 United States"),
    Location(sport: "Soccer", coordinates: [45.473373, -122.623280], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, please call 503-823-2525.", address: "3701 SE Bybee Blvd Portland, OR 97202 United States"),
    Location(sport: "Tennis", coordinates: [45.472703, -122.623059], notes: "2 lighted courts. Park hours: 5:00am-midnight. To reserve a sports field, please call 503-823-2525.", address: "3701 SE Bybee Blvd Portland, OR 97202 United States"),
    Location(sport: "Baseball", coordinates: [45.485858, -122.559754], notes: "2 fields. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "SE Steele St & SE 100th Ave Portland, OR  97266 United States"),
    Location(sport: "Soccer", coordinates: [45.484635, -122.559976], notes: "1 pitch. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "SE Steele St & SE 100th Ave Portland, OR  97266 United States"),
    Location(sport: "Basketball", coordinates: [45.485206, -122.559351], notes: "1 full court. Park hours: 5:00am-midnight.", address: "SE Steele St & SE 100th Ave Portland, OR  97266 United States"),
    Location(sport: "Volleyball", coordinates: [45.473448, -122.601778], notes: "2 courts. Park hours: 5:00am-midnight.", address: "6434 SE 60th Ave Portland, OR  97206 United States"),
    Location(sport: "Baseball", coordinates: [45.473484, -122.600823], notes: "1 field. Park hours: 5:00am-midnight.", address: "6434 SE 60th Ave Portland, OR  97206 United States"),
    Location(sport: "Soccer", coordinates: [45.473484, -122.600823], notes: "1 field. Park hours: 5:00am-midnight.", address: "6434 SE 60th Ave Portland, OR  97206 United States"),
    Location(sport: "Basketball", coordinates: [45.498846, -122.655126], notes: "1 full court. Street parking", address: "Brooklyn Park 3400 SE Milwaukie Ave Portland, OR  97202 United States"),
    Location(sport: "Baseball", coordinates: [45.498660, -122.654690], notes: "1 field. To reserve a sports field, call 503-823-2525. Street parking", address: "Brooklyn Park 3400 SE Milwaukie Ave Portland, OR  97202 United States"),
    Location(sport: "Basketball", coordinates: [45.504396, -122.605067], notes: "2 courts. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "2905 SE 55th Ave Portland, OR  97206 United States"),
    Location(sport: "Baseball", coordinates: [45.503625, -122.605116], notes: "2 fields. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "2905 SE 55th Ave Portland, OR  97206 United States"),
    Location(sport: "Soccer", coordinates: [45.503625, -122.605116], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "2905 SE 55th Ave Portland, OR  97206 United States"),
    Location(sport: "Baseball", coordinates: [45.515524, -122.646712], notes: " 1 field. Park hours: 5:00am-10:00pm. To reserve a sports field, please call 503-823-2525", address: "1925 SE Taylor St Portland, OR  97214 United States"),
    Location(sport: "Volleyball", coordinates: [45.515524, -122.646712], notes: "Park hours: 5:00am-10:00pm", address: "1925 SE Taylor St Portland, OR  97214 United States"),
    Location(sport: "Basketball", coordinates: [45.515371, -122.648201], notes: "1 court. Park hours: 5:00am-10:00pm", address: "1925 SE Taylor St Portland, OR  97214 United States"),
    Location(sport: "Tennis", coordinates: [45.516145, -122.646788], notes: "2 courts. Park hours: 5:00am-10:00pm", address: "1925 SE Taylor St Portland, OR  97214 United States"),
    Location(sport: "Volleyball", coordinates: [45.579415, -122.710805], notes: "Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "N Lombard Street and Woolsey Avenue Portland, OR 97203 United States"),
    Location(sport: "Tennis", coordinates: [45.580303, -122.709529], notes: "2 lighted courts. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "N Lombard Street and Woolsey Avenue Portland, OR 97203 United States"),
    Location(sport: "Baseball", coordinates: [45.579415, -122.710805], notes: "4 fields. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Lombard Street and Woolsey Avenue Portland, OR 97203 United States"),
    Location(sport: "Soccer", coordinates: [45.579415, -122.710805], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Lombard Street and Woolsey Avenue Portland, OR 97203 United States"),
    Location(sport: "Football", coordinates: [45.579415, -122.710805], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Lombard Street and Woolsey Avenue Portland, OR 97203 United States"),
    Location(sport: "Tennis", coordinates: [45.496701, -122.615507], notes: "Park hours: 5:00am-10:00pm", address: "SE 44th Avenue and Powell Blvd Portland, OR 97206"),
    Location(sport: "Soccer", coordinates: [45.597142, -122.680953], notes: "9 full size soccer pitches. Park hours: 6:00am-10:00pm. To reserve a sports field, call 503-643-1530.", address: "10850 N Denver Ave Portland, OR 97217 United States"),
    Location(sport: "Baseball", coordinates: [45.599835, -122.679385], notes: "7 fields. Park hours: 6:00am-10:00pm. To reserve a sports field, call 503-643-1530.", address: "10850 N Denver Ave Portland, OR 97217 United States"),
    Location(sport: "Volleyball", coordinates: [45.598823, -122.676207], notes: "6 courts. Park hours: 6:00am-10:00pm. To reserve a sports field, call 503-643-1530.", address: "10850 N Denver Ave Portland, OR 97217 United States"),
    Location(sport: "Basketball", coordinates: [45.557494, -122.659729], notes: "1 court. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "NE 6th Avenue and Humboldt Street Portland, OR 97211"),
    Location(sport: "Soccer", coordinates: [45.556819, -122.660006], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "NE 6th Avenue and Humboldt Street Portland, OR 97211"),
    Location(sport: "Baseball", coordinates: [45.556819, -122.660006], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "NE 6th Avenue and Humboldt Street Portland, OR 97211"),
    Location(sport: "Basketball", coordinates: [45.495179, -122.557975], notes: "1 court. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "100th SE Avenue and Powell Blvd Portland, OR 97266 United States"),
    Location(sport: "Soccer", coordinates: [45.495179, -122.557975], notes: "2 fields. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "100th SE Avenue and Powell Blvd Portland, OR 97266 United States"),
    Location(sport: "Tennis", coordinates: [45.494158, -122.584336], notes: "2 lighted courts. Park hours: 5:00am-midnight.", address: "SE 79th Avenue and Center Street Portland, OR 97206 United States"),
    Location(sport: "Baseball", coordinates: [45.494206, -122.583251], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 79th Avenue and Center Street Portland, OR 97206 United States"),
    Location(sport: "Basketball", coordinates: [45.494381, -122.584319], notes: "1 court. Park hours: 5:00am-midnight.", address: "SE 79th Avenue and Center Street Portland, OR 97206 United States"),
    Location(sport: "Baseball", coordinates: [45.565998, -122.623550], notes: "2 fields. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "NE 37th Avenue and Ainsworth Street Portland, OR 97211 United States"),
    Location(sport: "Soccer", coordinates: [45.565998, -122.623550], notes: "1 pitch. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "NE 37th Avenue and Ainsworth Street Portland, OR 97211 United States"),
    Location(sport: "Tennis", coordinates: [45.565998, -122.623550], notes: "2 tennis courts. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "NE 37th Avenue and Ainsworth Street Portland, OR 97211 United States"),
    Location(sport: "Volleyball", coordinates: [45.474188, -122.720975], notes: "Park hours: 5:00am-midnight. Parking lot off SW Canby closed at 10:00pm. To reserve a sports field or picnic area, call 503-823-2525", address: "SW 45th Ave & Vermont St Portland, OR 97219 United States"),
    Location(sport: "Tennis", coordinates: [45.473575, -122.721608], notes: "8 courts. Park hours: 5:00am-midnight. Parking lot off SW Canby closed at 10:00pm. To reserve a sports field or picnic area, call 503-823-2525", address: "SW 45th Ave & Vermont St Portland, OR 97219 United States"),
    Location(sport: "Baseball", coordinates: [45.474308, -122.717972], notes: "4 fields. Park hours: 5:00am-midnight. Parking lot off SW Canby closed at 10:00pm. To reserve a sports field, call 503-823-2525", address: "SW 45th Ave & Vermont St Portland, OR 97219 United States"),
    Location(sport: "Basketball", coordinates: [45.475246, -122.716622], notes: "1 court. Park hours: 5:00am-midnight. Parking lot off SW Canby closed at 10:00pm.", address: "SW 45th Ave & Vermont St Portland, OR 97219 United States"),
    Location(sport: "Tennis", coordinates: [45.539691, -122.629325], notes: "Park hours: 5:00am-midnight. To reserve a sports field call 503-823-2525.", address: "NE 33rd Avenue and US Grant Place Portland, OR 97212 United States"),
    Location(sport: "Tennis", coordinates: [45.539691, -122.629325], notes: "6 lighted courts. Park hours: 5:00am-midnight. To reserve a sports field call 503-823-2525.", address: "NE 33rd Avenue and US Grant Place Portland, OR 97212 United States"),
    Location(sport: "Basketball", coordinates: [45.540200, -122.627926], notes: "1 full court. Park hours: 5:00am-midnight.", address: "NE 33rd Avenue and US Grant Place Portland, OR 97212 United States"),
    Location(sport: "Soccer", coordinates: [45.538474, -122.628424], notes: "2 fields. Park hours: 5:00am-midnight.", address: "NE 33rd Avenue and US Grant Place Portland, OR 97212 United States"),
    Location(sport: "Baseball", coordinates: [45.538474, -122.628424], notes: "2 fields. Park hours: 5:00am-midnight.", address: "NE 33rd Avenue and US Grant Place Portland, OR 97212 United States"),
    Location(sport: "Football", coordinates: [45.538743, -122.629733], notes: "1 field. Park hours: 5:00am-midnight.", address: "NE 33rd Avenue and US Grant Place Portland, OR 97212 United States"),
    Location(sport: "Soccer", coordinates: [45.462494, -122.593217], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 67th Ave and Harney Street Portland, OR 97206 United States"),
    Location(sport: "Baseball", coordinates: [45.462494, -122.593217], notes: "2 fields. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 67th Ave and Harney Street Portland, OR 97206 United States"),
    Location(sport: "Basketball", coordinates: [45.462973, -122.594256], notes: "1 court. Park hours: 5:00am-midnight.", address: "SE 67th Ave and Harney Street Portland, OR 97206 United States"),
    Location(sport: "Soccer", coordinates: [45.492852, -122.698409], notes: "Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "SW Patrick Pl & SW Council Crest Dr Portland, OR  97239 United States"),
    Location(sport: "Basketball", coordinates: [45.492838, -122.698813], notes: "Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "SW Patrick Pl & SW Council Crest Dr Portland, OR  97239 United States"),
    Location(sport: "Basketball", coordinates: [45.527533, -122.709413], notes: "Park hours: 5:00am-midnight", address: "Hillside Park 653 NW Culpepper Terr Portland, OR  97210 United States"),
    Location(sport: "Soccer", coordinates: [45.527520, -122.708737], notes: "Park hours: 5:00am-midnight", address: "Hillside Park 653 NW Culpepper Terr Portland, OR  97210 United States"),
    Location(sport: "Tennis", coordinates: [45.490920, -122.632312], notes: "2 courts. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 34th Avenue and Holgate Blvd Portland, OR 97202"),
    Location(sport: "Baseball", coordinates: [45.491388, -122.632259], notes: "Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 34th Avenue and Holgate Blvd Portland, OR 97202"),
    Location(sport: "Soccer", coordinates: [45.583153, -122.690226], notes: "1 field. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "8417 N Brandon Avenue Portland, OR 97217"),
    Location(sport: "Baseball", coordinates: [45.583153, -122.690226], notes: "2 fields. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "8417 N Brandon Avenue Portland, OR 97217"),
    Location(sport: "Basketball", coordinates: [45.582940, -122.691263], notes: "1 court. Park hours: 5:00am-midnight.", address: "8417 N Brandon Avenue Portland, OR 97217"),
    Location(sport: "Baseball", coordinates: [45.493746, -122.594983], notes: " 1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 67th Avenue and Center Street Portland, OR 97206"),
    Location(sport: "Basketball", coordinates: [45.493191, -122.595050], notes: " 1 court. Park hours: 5:00am-midnight.", address: "SE 67th Avenue and Center Street Portland, OR 97206"),
    Location(sport: "Baseball", coordinates: [45.488908, -122.570944], notes: "Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "SE 92nd Ave & Holgate Blvd Portland, OR 97266 United States"),
    Location(sport: "Soccer", coordinates: [45.487410, -122.570751], notes: "1 pitch. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "SE 92nd Ave & Holgate Blvd Portland, OR 97266 United States"),
    Location(sport: "Basketball", coordinates: [45.485929, -122.569473], notes: "2 courts. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "SE 92nd Ave & Holgate Blvd Portland, OR 97266 United States"),
    Location(sport: "Tennis", coordinates: [45.485552, -122.569936], notes: "2 courts. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "SE 92nd Ave & Holgate Blvd Portland, OR 97266 United States"),
    Location(sport: "Basketball", coordinates: [45.550529, -122.529315], notes: "1 court. Park hours: 5:00am to midnight", address: "3546 NE 127th Ave Portland, OR  97230 United States"),
    Location(sport: "Soccer", coordinates: [45.549723, -122.530982], notes: "1 field. Park hours: 5:00am to midnight", address: "3546 NE 127th Ave Portland, OR  97230 United States"),
    Location(sport: "Baseball", coordinates: [45.581755, -122.732549], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Wall Avenue and Princeton Street Portland, OR 97203"),
    Location(sport: "Soccer", coordinates: [45.581755, -122.732549], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Wall Avenue and Princeton Street Portland, OR 97203"),
    Location(sport: "Basketball", coordinates: [45.581869, -122.733622], notes: "1 court. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "N Wall Avenue and Princeton Street Portland, OR 97203"),
    Location(sport: "Baseball", coordinates: [45.530806, -122.605888], notes: "Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "5700 NE Halsey St Portland, OR  97213 United States"),
    Location(sport: "Basketball", coordinates: [45.531757, -122.606687], notes: "1 court. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "5700 NE Halsey St Portland, OR  97213 United States"),
    Location(sport: "Football", coordinates: [45.532814, -122.606014], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "5700 NE Halsey St Portland, OR  97213 United States"),
    Location(sport: "Soccer", coordinates: [45.532814, -122.606014], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "5700 NE Halsey St Portland, OR  97213 United States"),
    Location(sport: "Volleyball", coordinates: [45.531669, -122.606928], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "5700 NE Halsey St Portland, OR  97213 United States"),
    Location(sport: "Tennis", coordinates: [45.589616, -122.724554], notes: "Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "9420 N Geneva Ave Portland, OR  97203 United States"),
    Location(sport: "Soccer", coordinates: [45.590306, -122.725671], notes: "1 pitch. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "9420 N Geneva Ave Portland, OR  97203 United States"),
    Location(sport: "Baseball", coordinates: [45.590306, -122.725671], notes: "2 fields. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "9420 N Geneva Ave Portland, OR  97203 United States"),
    Location(sport: "Baseball", coordinates: [45.548660, -122.682176], notes: "Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "1599 N Fremont St Portland, OR  97227 United States"),
    Location(sport: "Soccer", coordinates: [45.548660, -122.682176], notes: "Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "1599 N Fremont St Portland, OR  97227 United States"),
    Location(sport: "Basketball", coordinates: [45.548088, -122.682732], notes: "1 court. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "1599 N Fremont St Portland, OR  97227 United States"),
    Location(sport: "Baseball", coordinates: [45.480429, -122.731564], notes: "1 field. Park hours: 5:00am-midnight", address: "SW 55th Avenue and Iowa Street Portland, OR 97221"),
    Location(sport: "Soccer", coordinates: [45.480429, -122.731564], notes: "1 field. Park hours: 5:00am-midnight", address: "SW 55th Avenue and Iowa Street Portland, OR 97221"),
    Location(sport: "Baseball", coordinates: [45.603801, -122.758685], notes: "4 fields. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "10325 N Lombard St Portland, OR  97203 United States"),
    Location(sport: "Tennis", coordinates: [45.601291, -122.753432], notes: "2 courts. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "10325 N Lombard St Portland, OR  97203 United States"),
    Location(sport: "Basketball", coordinates: [45.601291, -122.753432], notes: "1 court. Park hours: 5:00am-midnight. To reserve a sports field or picnic area, call 503-823-2525.", address: "10325 N Lombard St Portland, OR  97203 United States"),
    Location(sport: "Baseball", coordinates: [45.504682, -122.707625], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SW Patton Road and Old Orchard Road Portland, OR 97201"),
    Location(sport: "Soccer", coordinates: [45.504682, -122.707625], notes: "1 field. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SW Patton Road and Old Orchard Road Portland, OR 97201"),
    Location(sport: "Basketball", coordinates: [45.504314, -122.708004], notes: "1 court. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SW Patton Road and Old Orchard Road Portland, OR 97201"),
    Location(sport: "Tennis", coordinates: [45.503951, -122.708036], notes: "2 courts. Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SW Patton Road and Old Orchard Road Portland, OR 97201"),
    Location(sport: "Baseball", coordinates: [45.498084, -122.642390], notes: "Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE 26th Avenue and Powell Blvd Portland, OR 97202"),
    Location(sport: "Soccer", coordinates: [45.498084, -122.642390], notes: "Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE 26th Avenue and Powell Blvd Portland, OR 97202"),
    Location(sport: "Basketball", coordinates: [45.497646, -122.640106], notes: "1 court. Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE 26th Avenue and Powell Blvd Portland, OR 97202"),
    Location(sport: "Tennis", coordinates: [45.538638, -122.598499], notes: "2 lighted courts. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "NE 62nd Avenue and Tillamook Street Portland, OR 97213"),
    Location(sport: "Baseball", coordinates: [45.538638, -122.598499], notes: "2 fields. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "NE 62nd Avenue and Tillamook Street Portland, OR 97213"),
    Location(sport: "Soccer", coordinates: [45.538638, -122.598499], notes: "1 field. Park hours: 5:00am-midnight To reserve a sports field, call 503-823-2525.", address: "NE 62nd Avenue and Tillamook Street Portland, OR 97213"),
    Location(sport: "Baseball", coordinates: [45.468475, -122.660238], notes: "2 fields. Park hours: 5:00am-midnight. Parking lot closed at 10:00pm. To reserve a sports field or picnic area, call 503-823-2525", address: "SE Seventh Ave Portland, OR 97202 United States"),
    Location(sport: "Football", coordinates: [45.468475, -122.660238], notes: "1 field. Park hours: 5:00am-midnight. Parking lot closed at 10:00pm. To reserve a sports field or picnic area, call 503-823-2525", address: "SE Seventh Ave Portland, OR 97202 United States"),
    Location(sport: "Soccer", coordinates: [45.468475, -122.660238], notes: "1 field. Park hours: 5:00am-midnight. Parking lot closed at 10:00pm. To reserve a sports field or picnic area, call 503-823-2525", address: "SE Seventh Ave Portland, OR 97202 United States"),
    Location(sport: "Tennis", coordinates: [45.466472, -122.660690], notes: "4 courts. Park hours: 5:00am-midnight. Parking lot closed at 10:00pm. To reserve a sports field or picnic area, call 503-823-2525", address: "SE Seventh Ave Portland, OR 97202 United States"),
    Location(sport: "Baseball", coordinates: [45.509558, -122.632941], notes: "Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 31st Avenue and Market Street Portland, OR 97214 United States"),
    Location(sport: "Soccer", coordinates: [45.509558, -122.632941], notes: "Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 31st Avenue and Market Street Portland, OR 97214 United States"),
    Location(sport: "Basketball", coordinates: [45.509558, -122.632941], notes: "Park hours: 5:00am-midnight. To reserve a sports field, call 503-823-2525.", address: "SE 31st Avenue and Market Street Portland, OR 97214 United States"),
    Location(sport: "Basketball", coordinates: [45.515273, -122.628986], notes: "Park hours: 5:00am-10:00pm", address: "SE 34th Ave & SE Taylor St Portland, OR  97214 United States"),
    Location(sport: "Soccer", coordinates: [45.515273, -122.628986], notes: "Park hours: 5:00am-10:00pm", address: "SE 34th Ave & SE Taylor St Portland, OR  97214 United States"),
    Location(sport: "Baseball", coordinates: [45.551423, -122.671202], notes: "1 feild. Park hours: 5:00am-midnight", address: "510 N Shaver Street Portland, OR 97227"),
    Location(sport: "Basketball", coordinates: [45.551423, -122.671202], notes: "2 courts. Park hours: 5:00am-midnight", address: "510 N Shaver Street Portland, OR 97227"),
    Location(sport: "Soccer", coordinates: [45.533254, -122.703815], notes: "1 field. Park hours: 5:00am-midnight. To reserve a picnic area or sports field, call 503-823-2525.", address: "NW Raleigh St & NW 25th Ave Portland, OR  97210 United States"),
    Location(sport: "Baseball", coordinates: [45.533254, -122.703815], notes: "2 fields. Park hours: 5:00am-midnight. To reserve a picnic area or sports field, call 503-823-2525.", address: "NW Raleigh St & NW 25th Ave Portland, OR  97210 United States"),
    Location(sport: "Basketball", coordinates: [45.533254, -122.703815], notes: "1 court. Park hours: 5:00am-midnight. To reserve a picnic area or sports field, call 503-823-2525.", address: "NW Raleigh St & NW 25th Ave Portland, OR  97210 United States"),
    Location(sport: "Tennis", coordinates: [45.473781, -122.640805], notes: "2 courts. Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE McLoughlin Blvd Portland, OR 97202 United States"),
    Location(sport: "Baseball", coordinates: [45.471026, -122.640939], notes: "5 fields. Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE McLoughlin Blvd Portland, OR 97202 United States"),
    Location(sport: "Football", coordinates: [45.471026, -122.640939], notes: "1 field. Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE McLoughlin Blvd Portland, OR 97202 United States"),
    Location(sport: "Soccer", coordinates: [45.471026, -122.640939], notes: "1 field. Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE McLoughlin Blvd Portland, OR 97202 United States"),
    Location(sport: "Basketball", coordinates: [45.468765, -122.641154], notes: "1 field. Park hours: 5:00am-midnight To reserve a sports field or picnic area, call 503-823-2525.", address: "SE McLoughlin Blvd Portland, OR 97202 United States"),
    Location(sport: "Tennis", coordinates: [45.474220, -122.670371], notes: "4 courts. 5:00am-10:00pm, Closed to vehicles at 10:00pm", address: "SW Macadam Avenue and Nebraska Street Portland, OR 97219 United States"),
    Location(sport: "Soccer", coordinates: [45.474751, -122.669609], notes: "2 fields. 5:00am-10:00pm, Closed to vehicles at 10:00pm", address: "SW Macadam Avenue and Nebraska Street Portland, OR 97219 United States"),
    Location(sport: "Soccer", coordinates: [45.552949, -122.628108], notes: "1 field. Park hours: 5:00am-midnight", address: "3460–3538 NE Skidmore St Portland, OR  97211 United States"),
    Location(sport: "Baseball", coordinates: [45.552949, -122.628108], notes: "2 fields. Park hours: 5:00am-midnight", address: "3460–3538 NE Skidmore St Portland, OR  97211 United States"),
    Location(sport: "Volleyball", coordinates: [45.552949, -122.628108], notes: "2 fields. Park hours: 5:00am-midnight", address: "3460–3538 NE Skidmore St Portland, OR  97211 United States"),
]

