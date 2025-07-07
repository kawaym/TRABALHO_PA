// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "./main.sol";

contract DegreeSystemTest {
    DegreeSystem ds;

    address owner;

    function beforeAll() public {
        ds = new DegreeSystem();
        owner = address(this);
    }

    function testRegisterProfessorAndCourse() public {
        ds.RegisterProfessor("Prof. Alice");
        ds.RegisterCourse("Math", "M101");
        ds.RegisterClass("M101");

        uint256 nextId = ds.nextClassId();
        Assert.equal(nextId, 2, "Class should be registered with ID 1");
    }

    function testRegisterStudentAndEnroll() public {
        ds.RegisterStudent(1001, "Alice Student");

        // Student should be enrolled
        ds.enrollStudent(1, 1001);

        bool enrolled = ds.isStudentEnrolled(1, 1001);
        Assert.ok(enrolled, "Student should be enrolled in class 1");
    }

    function testAssignDegree() public {
        // Assign a degree to student
        ds.assignDegree(1, 1001, 950);

        (uint256 value, bool exists) = ds.seeDegree(1, 1001);
        Assert.ok(exists, "Degree should exist");
        Assert.equal(value, 950, "Degree value should be 950");
    }

    function testAlterDegree() public {
        // Alter degree value
        ds.alterDegree(1, 1001, 880);

        (uint256 value, bool exists) = ds.seeDegree(1, 1001);
        Assert.ok(exists, "Degree should still exist");
        Assert.equal(value, 880, "Degree value should be updated to 880");
    }

    function testSeeAllDegreesClass() public {
        ds.RegisterStudent(1002, "Bob Student");
        ds.enrollStudent(1, 1002);
        ds.assignDegree(1, 1002, 700);

        (uint256[] memory enrollments, uint256[] memory values) = ds
            .seeAllDegreesClass(1);

        Assert.equal(
            enrollments.length,
            2,
            "Should have 2 enrolled students with degrees"
        );
        Assert.equal(values[0], 880, "First degree value should be 880");
        Assert.equal(values[1], 700, "Second degree value should be 700");
    }
}
