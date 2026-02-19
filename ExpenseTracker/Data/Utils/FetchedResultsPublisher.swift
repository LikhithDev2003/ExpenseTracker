//
//  FetchedResultsPublisher.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import Foundation
import CoreData
import Combine

final class FetchedResultsPublisher<Result: NSFetchRequestResult>:NSObject, NSFetchedResultsControllerDelegate, Publisher {

    typealias Output = [Result]
    typealias Failure = Never

    private let fetchedResultsController: NSFetchedResultsController<Result>

    private let subject = CurrentValueSubject<[Result], Never>([])

    init(
        fetchRequest: NSFetchRequest<Result>,
        context: NSManagedObjectContext
    ) {

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            subject.send(
                fetchedResultsController.fetchedObjects ?? []
            )
        } catch {
            print("Fetch failed \(error)")
        }
    }
    

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, [Result] == S.Input {

        subject.receive(subscriber: subscriber)
    }

    
    func controllerDidChangeContent( _ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        subject.send(
            fetchedResultsController.fetchedObjects ?? []
        )
    }
}
