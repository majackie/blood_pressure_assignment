//
//  FamilyMemberDetailView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct ZodiacAnimalDetailView: View {
    let member: FamilyMember
    
    var body: some View {
        VStack {
            Text(member.name)
                .padding()
            Text(member.email)
        }
    }
}
