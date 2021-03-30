import SwiftUI

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @State var interval: DateInterval = DateInterval()

    @State var year: Int = Date().get(.year)
    let showHeaders: Bool
    let content: (Date) -> DateView
    init(
        showHeaders: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.showHeaders = showHeaders
        self.content = content
    }
    
    var body: some View {
        ZStack{
            Background()
        ScrollViewReader { scrollView in
            VStack{
                HStack{
                    Button(action: {decreaseYear()}, label: {
                        Image(systemName: "chevron.left.2")
                    })
                    Spacer()
                    Text(String(year))
                    Spacer()
                    Button(action: {increaseYear()}, label: {
                        Image(systemName: "chevron.right.2")
                    })
                }.padding([.top, .horizontal])
                ScrollView{
                    let monthHeaders = getMonthHeaders()
                    let monthToDays = getMonthToDays()

                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                        ForEach(Array(getMonths().enumerated()), id: \.offset) { (index,month) in
                            Section(header: headerView(for: monthHeaders[index])) {
                                if let days = monthToDays[month] {
                                    ForEach(days, id: \.self) { date in
                                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                            content(date).id(date)
                                        } else {
                                            content(date).hidden()
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                }.onAppear(perform: {
                    withAnimation{
                        scrollView.scrollTo(Date().get(.month) - 1, anchor: .top)
                    }
                    interval = getInterval(year: Date().get(.year))
                })
            }
        }
        }
    }
    func getMonths() -> [Date]{
        return calendar.generateDates(
            inside: self.interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    func getMonthHeaders() -> [String]{
        var monthHeaders: [String] = []
        let months = getMonths()
        for month in months {
            if showHeaders {
                monthHeaders += [header(for: month)]
            }
        }
        return monthHeaders
    }
    func getMonthToDays() -> [Date: [Date]]{
        var monthToDays: [Date: [Date]] = [:]
        let months = getMonths()
        for month in months {
            monthToDays[month] = days(for: month)
        }
        return monthToDays
    }
    func increaseYear(){
        year = year + 1
        interval = getInterval(year: year)
    }
    func getInterval(year: Int) -> DateInterval{
        let dateComponents = DateComponents(year: year)
        let startOfYear = Calendar.current.date(from: dateComponents)!
        var endComponents = DateComponents(year: year)
        endComponents.year = (endComponents.year ?? 0) + 1
        endComponents.hour = (endComponents.hour ?? 0) - 1
        let yearEnd = Calendar.current.date(from: endComponents)!
        return DateInterval(start: startOfYear, end: yearEnd)
    }
    
    func decreaseYear(){
        year = year - 1
        interval = getInterval(year: year)
    }
    
    private func headerView(for month:String) -> some View {
        HStack{
            Text(month)
                .font(.headline)
            Spacer()
        }.padding(.top, 30).padding(.bottom, 4)
        
    }
    
    private func header(for month: Date) -> String {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return formatter.string(from: month)
    }
    
    private func days(for month: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView() { _ in
            Text("30")
                .padding(8)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
