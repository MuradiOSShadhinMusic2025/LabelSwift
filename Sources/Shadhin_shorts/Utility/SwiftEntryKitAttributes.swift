//
//  SwiftEcnty.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 24/3/25.
//

class SwiftEntryKitAttributes {
    
    static func bottomAlertAttributes(viewHeight: CGFloat)->EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes = .bottomFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: EKColor.black.with(alpha: 0.7))
        
        attributes.entryBackground = .color(color: .white)
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        //attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.35))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.35)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
        attributes.positionConstraints.size = .init(width: .fill, height: .fill)
        //attributes.roundCorners = .all(radius: 8)
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden
        
        return attributes
    }
    
    static func bottomFullScAlertAttributes()->EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes = .bottomFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: EKColor.black.with(alpha: 0.7))
        attributes.entryBackground = .color(color: .white)
        attributes.positionConstraints.size = .init(width: .fill, height: .fill)
        attributes.entryInteraction = .absorbTouches    // entry ভিউ ক্লিক করলে dismiss হবে না
        attributes.screenInteraction = .dismiss        // entry ভিউ ছাড়া বাকি জায়গায় ক্লিক dismiss করবে
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.35))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.35)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
        attributes.positionConstraints.size = .init(width: .fill, height: .fill)
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden
        
        return attributes
    }
    
    static func bottomAlertAttributesRound(height: CGFloat, offsetValue: CGFloat)-> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        //attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: EKColor.black.with(alpha: 0.7))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.roundCorners = .all(radius: 8)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)),
                                             scale: .init(from: 1.05, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.3))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3)))
        //attributes.positionConstraints.verticalOffset = 10
        attributes.positionConstraints.size = .init(width: .offset(value: offsetValue), height: .constant(value: height))
        //attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        //attributes.positionConstraints.safeArea = .overridden
        return attributes
    }
    
    static func bottomAlertWrapAttributesRound(offsetValue: CGFloat)-> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        //attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: EKColor.black.with(alpha: 0.7))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.roundCorners = .all(radius: 8)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)),
                                             scale: .init(from: 1.05, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.3))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3)))
        //attributes.positionConstraints.verticalOffset = 10
        //attributes.positionConstraints.size = .init(width: .offset(value: offsetValue), height: .)
        //attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        //attributes.positionConstraints.safeArea = .overridden
        return attributes
    }
}
