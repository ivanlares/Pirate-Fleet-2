//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
  let x: Int
  let y: Int
}

struct Ship {
  let length: Int
  let location: GridLocation
  let isVertical: Bool
  var isWooden: Bool
  
  var cells: [GridLocation] {
    get {
      let start = self.location
      let end: GridLocation = ShipEndLocation(self)
      
      var occupiedCells = [GridLocation]()
      for x in start.x...end.x {
        for y in start.y...end.y {
          occupiedCells.append(GridLocation(x: x, y: y))
        }
      }
      
      return occupiedCells
    }
  }
  
  var hitTracker: HitTracker

  var sunk: Bool {
    get {
      for (_, isHit) in hitTracker.cellsHit {
        if isHit == false {
          return false
        }
      }
      return true
    }
  }
  

  init(length: Int, location: GridLocation, isVertical: Bool) {
    self.length = length
    self.hitTracker = HitTracker()
    self.isWooden = true
    self.location = location
    self.isVertical = isVertical
  }
  
  init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool){
    self.length = length
    self.hitTracker = HitTracker()
    self.location = location
    self.isVertical = isVertical
    self.isWooden = isWooden
  }
  
}

protocol PenaltyCell {
  var location: GridLocation {get}
  var guaranteesHit: Bool {get}
  var penaltyText: String {get}
}

struct Mine: PenaltyCell {
  let location: GridLocation
  let guaranteesHit: Bool
  let penaltyText: String
  
  init(location: GridLocation, penaltyText: String) {
    self.location = location
    self.penaltyText = penaltyText
    self.guaranteesHit = false
  }
  
  init(location: GridLocation, guaranteesHit: Bool, penaltyText: String) {
    self.location = location
    self.penaltyText = penaltyText
    self.guaranteesHit = guaranteesHit
  }
  
}

struct SeaMonster: PenaltyCell {
  let location: GridLocation
  let guaranteesHit: Bool
  let penaltyText: String
}

class ControlCenter {
  
  func placeItemsOnGrid(human: Human) {
    
    let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: true)
    human.addShipToGrid(smallShip)

    let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
    human.addShipToGrid(mediumShip1)

    let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
    human.addShipToGrid(mediumShip2)
    
    let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true)
    human.addShipToGrid(largeShip)
    
    let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
    human.addShipToGrid(xLargeShip)
    
    let mine1 = Mine(location: GridLocation(x: 6, y: 0), guaranteesHit: true, penaltyText: "Boom")
    human.addMineToGrid(mine1)
    
    let mine2 = Mine(location: GridLocation(x: 3, y: 3), guaranteesHit: true, penaltyText: "Boom")
    human.addMineToGrid(mine2)
    
    let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), guaranteesHit: true, penaltyText: "Ahh")
    human.addSeamonsterToGrid(seamonster1)
    
    let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), guaranteesHit: true, penaltyText: "Ahh")
    human.addSeamonsterToGrid(seamonster2)
  }
  
  func calculateFinalScore(gameStats: GameStats) -> Int {
    
    var finalScore: Int
    
    let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
    let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
    let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
    
    finalScore = sinkBonus + shipBonus - guessPenalty
    
    return finalScore
  }
}