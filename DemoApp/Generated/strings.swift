// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Albums {
    /// Albums
    internal static let title = L10n.tr("Localizable", "Albums.title")
  }

  internal enum Alert {
    /// OK
    internal static let defaultAction = L10n.tr("Localizable", "Alert.DefaultAction")
    internal enum AvailableLater {
      /// This feature will be release more later this year
      internal static let message = L10n.tr("Localizable", "Alert.AvailableLater.message")
      /// Available soonly...
      internal static let title = L10n.tr("Localizable", "Alert.AvailableLater.title")
    }
  }

  internal enum Comment {
    /// %@ says 
    internal static func say(_ p1: String) -> String {
      return L10n.tr("Localizable", "Comment.say", p1)
    }
    internal enum CommentPosted {
      /// Thank you, it will be moderate before displayed (approximatively 24h)
      internal static let body = L10n.tr("Localizable", "Comment.commentPosted.body")
      /// Comment sent !
      internal static let title = L10n.tr("Localizable", "Comment.commentPosted.title")
    }
    internal enum EmptyMessage {
      /// You should write message for posting comment
      internal static let body = L10n.tr("Localizable", "Comment.emptyMessage.body")
      /// Empty message
      internal static let title = L10n.tr("Localizable", "Comment.emptyMessage.title")
    }
    internal enum ErrorMessage {
      /// An error has coming, please retry later
      internal static let body = L10n.tr("Localizable", "Comment.errorMessage.body")
      /// Oups
      internal static let title = L10n.tr("Localizable", "Comment.errorMessage.title")
    }
  }

  internal enum User {
    internal enum Post {
      internal enum Comment {
        /// Loading...
        internal static let loading = L10n.tr("Localizable", "User.post.comment.loading")
        ///  %d comment(s)
        internal static func number(_ p1: Int) -> String {
          return L10n.tr("Localizable", "User.post.comment.number", p1)
        }
      }
    }
  }

  internal enum Users {
    /// Users
    internal static let title = L10n.tr("Localizable", "Users.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
