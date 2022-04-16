//
//  CalenderDatePicker.swift
//  Any2Do
//
//  Created by Mint on 2022/2/26.
//

import SwiftUI

struct CalendarDatePickerView: View {
    
    @ObservedObject var viewModel: CategoryTaskViewModel
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.taskReminder, ascending: true)]
    ) var allTask: FetchedResults<Task>
    
    let days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let geometry: GeometryProxy
    
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {
                    Constants.haptic.light.impactOccurred()
                    withAnimation{
                        currentMonth -= 1
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: geometry.size.width/15))
                })
                
                Spacer(minLength: 0)
                Text(displayMonth()[0])
                    .font(.system(size: geometry.size.width/12))
                    .fontWeight(.bold)
                Text(displayMonth()[1])
                    .font(.system(size: geometry.size.width/15))
                    .fontWeight(.semibold)
                Spacer(minLength: 0)
                
                Button(action: {
                    Constants.haptic.light.impactOccurred()
                    withAnimation{
                        currentMonth += 1
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: geometry.size.width/15))
                })
            }
            .padding([.vertical,.horizontal])
            
            HStack(spacing: 0) {
                ForEach(days, id:\.self) { day in
                    Text(day)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(extractDate()) { value in
                    CalendarCardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color("Purple"))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0 )
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            .padding(.vertical)
            
            VStack(spacing: 15) {
                Text("Task")
                    .font(.system(size: geometry.size.width/15))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                if let calendarTask = allTask.filter({ task in
                    isSameDay(date1: task.taskReminder ?? Date(), date2: currentDate)
                }) {
                    ForEach(calendarTask) { task in
                        HStack{
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(taskDate(date:task.taskReminder))
                                    .font(.system(size: geometry.size.width/25))
                                    .foregroundColor(.white)
                                    .strikethrough(task.taskDone ? true : false)
                                Text(task.taskName ?? " ")
                                    .font(.system(size: geometry.size.width/18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .strikethrough(task.taskDone ? true : false)
                            }
                            Spacer()
                            Image(systemName: task.taskFlag ? "flag.fill" : "flag")
                                .font(.system(size: geometry.size.width/12))
                                .foregroundColor(task.taskFlag ? Color("Red"): .white )
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .background(
                            Color("Blue")
                                .opacity(0.8)
                                .cornerRadius(10)
                        )
                    }
                } else {
                    Text("No Task Found")
                }
            }
            .padding()
        }
        .onChange(of: currentMonth) { newValue in
            //update month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CalendarCardView(value: CalendarDateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = allTask.first(where: { task in
                    return isSameDay(date1: task.taskReminder ?? Date(), date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.system(size: geometry.size.width/20))
                        .fontWeight(.semibold)
                        .foregroundColor(isSameDay(date1: task.taskReminder ?? Date(), date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: task.taskReminder ?? Date(), date2: currentDate) ? .white : Color("Purple"))
                        .frame(width: 8, height: 8)
                    
                } else {
                    Text("\(value.day)")
                        .font(.system(size: geometry.size.width/20))
                        .fontWeight(.semibold)
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    func taskDate(date: Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        let date = formatter.string(from: date ?? Date())
        return date
    }
    
    func isSameDay(date1: Date, date2: Date) ->Bool{
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func displayMonth() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
        
    }
    
    func getCurrentMonth() -> Date{
        let calendar = Calendar.current
        //getting current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [CalendarDateValue] {
        let calendar = Calendar.current
        //getting current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> CalendarDateValue in
            //getting day
            let day = calendar.component(.day, from: date)
            return CalendarDateValue(day: day, date: date)
        }
        
        //adding offset days to get exact week day..The absolute time for which the calculation is performed.
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday-1 {
            days.insert(CalendarDateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}


//extending date to get current month dates...
extension Date {
    func getAllDates() -> [Date]{
        
        let calendar = Calendar.current
        
        //getting startdate
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        //getting date
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day - 1,to: startDate)!
        }
    }
}

struct CalenderDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHomeView(viewModel: CategoryTaskViewModel())
    }
}
