import SwiftUI

struct PluginDetailsView: View {
    @ObservedObject var md: PluginMetadata
    let plugin: Plugin
    @State var isEditing: Bool = false
    @State var dependencies: String = ""
    let screenProportion: CGFloat = 0.3
    let width: CGFloat = 400
    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                Form {
                    Section(header: Text("About Plugin")) {
                        PluginDetailsTextView(label: "Name",
                                              text: $md.name,
                                              width: width * screenProportion)
                        PluginDetailsTextView(label: "Description",
                                              text: $md.desc,
                                              width: width * screenProportion)
                        PluginDetailsTextView(label: "Dependencies",
                                              text: $dependencies,
                                              width: width * screenProportion)
                            .onAppear(perform: {
                                dependencies = md.dependencies.joined(separator: ",")
                            })
                        HStack {
                            PluginDetailsTextView(label: "GitHub",
                                                  text: $md.github,
                                                  width: width * screenProportion)
                            PluginDetailsTextView(label: "Author",
                                                  text: $md.author,
                                                  width: width * 0.2)
                        }
                        HStack {
                            PluginDetailsTextView(label: "Version",
                                                  text: $md.version,
                                                  width: width * screenProportion)
                            PluginDetailsTextView(label: "Schedule",
                                                  text: $md.schedule,
                                                  width: width * 0.2)
                        }
                    }

                    Section(header: Text("Hide Standard Menu Items")) {
                        PluginDetailsToggleView(label: "About",
                                                state: $md.hideAbout,
                                                width: width * screenProportion)
                        PluginDetailsToggleView(label: "Run In Terminal",
                                                state: $md.hideRunInTerminal,
                                                width: width * screenProportion)
                        PluginDetailsToggleView(label: "Last Updated",
                                                state: $md.hideLastUpdated,
                                                width: width * screenProportion)
                        PluginDetailsToggleView(label: "Disable Plugin",
                                                state: $md.hideDisablePlugin,
                                                width: width * screenProportion)
                        PluginDetailsToggleView(label: "SwiftBar",
                                                state: $md.hideSwiftBar,
                                                width: width * screenProportion)
                    }
                }
            }.padding(8)
            HStack {
                Spacer()
                Button("Save", action: {
                    PluginMetadata.writeMetadata(metadata: md, fileURL: URL(fileURLWithPath: plugin.file))
                }).padding([.trailing])
            }
        }
    }
}

struct PluginDetailsTextView: View {
    @EnvironmentObject var preferences: Preferences
    let label: String
    @Binding var text: String
    let width: CGFloat
    var body: some View {
        HStack {
            HStack {
                Spacer()
                Text("\(label):")
            }.frame(width: width)
            TextField("", text: $text)
                .disabled(!preferences.pluginDeveloperMode)
            Spacer()
        }
    }
}

struct PluginDetailsToggleView: View {
    let label: String
    @Binding var state: Bool
    let width: CGFloat
    var body: some View {
        HStack {
            HStack {
                Spacer()
                Text("\(label):")
            }.frame(width: width)
            Toggle("", isOn: $state)
        }
    }
}
