//
//  EditProjectView.swift
//  TrackWishes
//
//  Created by Gokhan Bozkurt on 9.08.2022.
//
import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    @ObservedObject var  project: Project
    @EnvironmentObject var dataConroller: DataController
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    @State private var engine = try? CHHapticEngine()
    
    @State private var showingErrorNotification = false
    
    
    @State private var remindMe: Bool
    @State private var reminderTime: Date
    let colorColums = [
        GridItem(.adaptive(minimum: 44))
    ]
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
        
        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            } header: {
                Text("Basic settings")
            }
            
            Section {
                LazyVGrid(columns: colorColums) {
                    ForEach(Project.colors, id: \.self) { item in
                       colorButton(for: item)
                    }
                }.padding(.vertical)
            } header: {
                Text("Custom project color")
            }
            
            Section {
                Toggle("Show Reminders", isOn: $remindMe.animation().onChange(update))
                    .alert("Oppps!",isPresented: $showingErrorNotification) {
                        Button("Check Settings") { showAppSettings() }
                        Button("Cancel", role: .cancel) {  }
                    } message: {
                        Text("There was a problem.Please check you have notifications enabled.")
                    }
                if remindMe {
                    DatePicker("Reminder Time", selection: $reminderTime.onChange(update), displayedComponents: .hourAndMinute)
                }
            } header: {
                Text("Project Reminders")
            }
            
            Section() {
                Button(project.closed ? "Reopen this project" : "Close this project",action: toggleClosed)
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
             
                }
                .tint(.red)
            } footer: {
                Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.") // swiftlint:disable:this line_
            }
        }.navigationTitle("Edit Project")
            .onDisappear(perform: dataConroller.save)
            .alert("Delete project?", isPresented: $showingDeleteConfirm) {
                Button("Cancel", role: .cancel) {  }
                Button("Delete",role: .destructive) { delete() }
               
            } message: {
                Text("Are you sure you want to delete this project? You will also delete all the items it contains.") // swiftlint:disable:this line_
            }
    }
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
        
        
        if remindMe {
            project.reminderTime = reminderTime
            dataConroller.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false
                    showingErrorNotification = true
                }
            }
        } else {
            project.reminderTime = nil
            dataConroller.removeReminders(for: project)
        }
    }
    func delete() {
        dataConroller.delete(project)
        dismiss()
    }
    
    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }
    func toggleClosed() {
        project.closed.toggle()
        if project.closed {
            do {
                try engine?.start()
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                
                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
                
                let paramater = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start,end],
                    relativeTime: 0)
                
                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity,sharpness],
                    relativeTime: 0)
                
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [intensity,sharpness],
                    relativeTime: 0.125,
                    duration: 1)
                
                let pattern = try CHHapticPattern(
                    events: [event1,event2],
                    parameterCurves: [paramater])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                
            }
        }
    }
    func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}


