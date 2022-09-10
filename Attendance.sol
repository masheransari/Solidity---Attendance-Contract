// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract Attendance{

    enum MonthEnum {
        JANUARY,
        FEBUARY,
        MARCH,
        APRIL,
        MAY,
        JUNE,
        JULY,
        AUGUST,
        SEPTEMBER,
        OCTOBER,
        NOVEMBER,
        DECEMBER
    }

    struct StudentFees{
        // address studentAddress;
        // MonthEnum MonthEnum;
        uint amount;
        bool isPaid;
    }

    struct StudentAttendance{
        uint date;
        bool isPresent;
    }

    MonthEnum currentMonth;
    uint currentDate;

    mapping(address => mapping(MonthEnum => StudentFees)) mapHistory;
    mapping(address => mapping(MonthEnum => mapping(uint => StudentAttendance))) attendanceHistory;

    //First Set Month and Date.
    function setCurrentMonth(MonthEnum _month, uint _date) public{
        currentMonth = _month;
        currentDate = _date;
    }

    //to check the student is paid for the current month fees or not.
    function isStudentPaidForCurrentMonth(address _address) public view returns(bool){
        return mapHistory[_address][currentMonth].isPaid;
    }

    //to check the student is paid for the other/selected month fees or not.
    function isStudentPaidForOtherMonth(address _address, MonthEnum monthEnum) public view returns(bool){
        return mapHistory[_address][monthEnum].isPaid;
    }
    
    //To mark the current month fees paid.
    function postCurrentMonthPaid(address _address) public payable {
        require(!mapHistory[_address][currentMonth].isPaid,"Fees Alredy Paid");
        require(msg.value == 1 ether, "Please pay 0.1 Ether for your children fee");
        mapHistory[_address][currentMonth] = StudentFees(msg.value,true);
    }
    
    //To mark the other month fees pay section.
    function postOtherMonthPaid(address _address, MonthEnum monthEnum) public payable {
        require(!mapHistory[_address][monthEnum].isPaid,"Fees Alredy Paid");
        require(msg.value == 1 ether, "Please pay 0.1 Ether for your children fee");
        mapHistory[_address][monthEnum] = StudentFees(msg.value,true);
    }

    //To mark today date attendance.
    function markTodayAttendance(address _address) public {
        require(mapHistory[_address][currentMonth].isPaid,"Fees Not paid, kindly pay the current month fee first");
        require(!attendanceHistory[_address][currentMonth][currentDate].isPresent,"Already mark as present");
        attendanceHistory[_address][currentMonth][currentDate] = StudentAttendance(currentDate,true);
    }

    //To mark today date attendance.
    function markSpecificDateAttendance(address _address,uint date) public {
        require(mapHistory[_address][currentMonth].isPaid,"Fees Not paid, kindly pay the current month fee first");
        require(!attendanceHistory[_address][currentMonth][date].isPresent,"Already mark as present");
        attendanceHistory[_address][currentMonth][date] = StudentAttendance(date,true);
    }

    //To mark other month and specific date attendance mark.
    function markOtherMonthDateAttendance(address _address, MonthEnum monthEnum, uint date) public {
        require(mapHistory[_address][monthEnum].isPaid,"Fees Not paid, kindly pay the other month fee first");
        require(!attendanceHistory[_address][monthEnum][date].isPresent,"Already mark as present");
        attendanceHistory[_address][monthEnum][date] = StudentAttendance(date,true);
    }


}