//
//  ComplicationController.swift
//  SpeedyContactAdd WatchKit Extension
//
//  Created by Aaron Haughton on 7/16/16.
//  Copyright © 2016 AlphaGradeINC. All rights reserved.
//

import ClockKit

// MARK: - Timeline Configuration

func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
    handler([.forward, .backward])
}

private func getTimelineStartDate(for complication: CLKComplication, withHandler handler: (Date) -> Void) {
    //    handler(nil)
}

private func getTimelineEndDate(for complication: CLKComplication, withHandler handler: (Date) -> Void) {
    //     handler(nil)
}

func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.showOnLockScreen)
}

// MARK: - Timeline Population

func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
    // Call the handler with the current timeline entry
    handler(nil)
}

func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries prior to the given date
    handler(nil)
}

func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
    // Call the handler with the timeline entries after to the given date
    handler(nil)
}

// MARK: - Update Scheduling

private func getNextRequestedUpdateDate(handler: (Date) -> Void) {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    //    handler(nil);
}

// MARK: - Complications for App
func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void ) {
    
    
    let modComp = CLKComplicationTemplateModularSmallSimpleImage()
    
    modComp.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Modular"))
    
    let cirComp = CLKComplicationTemplateCircularSmallSimpleImage()
    
    cirComp.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Circular"))
    
    let utilComp = CLKComplicationTemplateModularSmallSimpleImage()
    
    utilComp.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Utilitarian"))
    
}






