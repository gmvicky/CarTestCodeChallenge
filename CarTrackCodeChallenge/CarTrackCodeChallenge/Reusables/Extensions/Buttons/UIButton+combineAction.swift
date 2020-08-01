//
//  UIButton+combineAction.swift
//  PrivatePod4
//
//  Created by WT-iOS on 20/2/20.
//

import UIKit
import Combine

extension UIButton: CustomButtonCombineCompatible {
    
    var action: CustomButtonPublisher {
        return publisher()
    }
}


/// Extending the `UIButton` types to be able to produce a `UIControl.Event` publisher.
protocol CustomButtonCombineCompatible { }

extension CustomButtonCombineCompatible where Self: UIButton {
    func publisher() -> CustomButtonPublisher {
        return CustomButtonPublisher(control: self)
    }
}



/// A custom `Publisher` to work with our custom `UIControlSubscription`.
struct CustomButtonPublisher: Publisher {
    
    typealias Output = ()
    typealias Failure = Never

    let control: UIButton
    let controlEvents = UIControl.Event.touchUpInside

    init(control: UIButton) {
        self.control = control
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == CustomButtonPublisher.Failure, S.Input == CustomButtonPublisher.Output {
        let subscription = CustomButtonSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

/// A custom subscription to capture UIControl target events.
final class CustomButtonSubscription<SubscriberType: Subscriber, Control: UIButton>: Subscription where SubscriberType.Input == Void {
    
    private var subscriber: SubscriberType?
    
    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: //https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive()
    }
}

