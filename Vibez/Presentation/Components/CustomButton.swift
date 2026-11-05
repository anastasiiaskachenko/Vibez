import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    enum Variant {
        case primary
        case secondary
    }

    var variant: Variant = .primary
    var fillAccent: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(backgroundView)
            .foregroundStyle(Color.white)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .fill(.white)
                    .opacity(configuration.isPressed ? 0.3 : 0)
            )
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(
                .spring(response: 0.3, dampingFraction: 0.45),
                value: configuration.isPressed)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primary:
            if fillAccent {
                Color.accent.opacity(0.9)
            } else {
                glassyBg
            }
        case .secondary:
            glassyBg
        }
    }

    private var glassyBg: some View {
        Capsule()
            .fill(.ultraThinMaterial)
            .overlay(
                Capsule()
                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
            )
    }
}

extension ButtonStyle where Self == CustomButtonStyle {
    static var primaryAction: CustomButtonStyle {
        CustomButtonStyle(variant: .primary, fillAccent: true)
    }

    static func primaryAction(fillAccent: Bool) -> CustomButtonStyle {
        CustomButtonStyle(variant: .primary, fillAccent: fillAccent)
    }

    static var secondaryAction: CustomButtonStyle {
        CustomButtonStyle(variant: .secondary)
    }
}
