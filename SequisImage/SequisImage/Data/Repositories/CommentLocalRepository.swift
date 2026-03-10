//
//  CommentLocalRepository.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import CoreData
import Foundation

final class CommentLocalRepository: CommentLocalRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func getComments(forImageId imageId: String) -> [CommentItem] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CommentEntity")
        request.predicate = NSPredicate(format: "imageId == %@", imageId)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            let entities = try context.fetch(request)
            return entities.compactMap { mapToDomain(entity: $0) }
        } catch {
            print("Failed to fetch comments: \(error)")
            return []
        }
    }

    func save(comment: CommentItem) {
        let entity = NSEntityDescription.insertNewObject(
            forEntityName: "CommentEntity", into: context)
        entity.setValue(comment.id, forKey: "id")
        entity.setValue(comment.imageId, forKey: "imageId")
        entity.setValue(comment.authorInitials, forKey: "authorInitials")
        entity.setValue(comment.authorName, forKey: "authorName")
        entity.setValue(comment.text, forKey: "text")
        entity.setValue(comment.createdAt, forKey: "createdAt")

        saveContext()
    }

    func delete(commentId: UUID, forImageId imageId: String) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CommentEntity")
        request.predicate = NSPredicate(
            format: "id == %@ AND imageId == %@", commentId as CVarArg, imageId)

        do {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            saveContext()
        } catch {
            print("Failed to delete comment: \(error)")
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    private func mapToDomain(entity: NSManagedObject) -> CommentItem? {
        guard let id = entity.value(forKey: "id") as? UUID,
            let imageId = entity.value(forKey: "imageId") as? String,
            let authorInitials = entity.value(forKey: "authorInitials") as? String,
            let authorName = entity.value(forKey: "authorName") as? String,
            let text = entity.value(forKey: "text") as? String,
            let createdAt = entity.value(forKey: "createdAt") as? Date
        else {
            return nil
        }
        return CommentItem(
            id: id, imageId: imageId, authorInitials: authorInitials, authorName: authorName,
            text: text, createdAt: createdAt)
    }
}
