// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegreeSystem {
    struct Student {
        string privateName;
        uint256 enrollment;
        bool itExists;
    }

    mapping(uint256 => Student) public students;

    event StudentRegistered(
        uint256 indexed enrollment,
        address indexed sender_addr
    );

    modifier onlyStudent(uint256 enrollment) {
        require(students[enrollment].itExists, "Student not found");
        require(msg.sender != address(0), "Invalid address");
        _;
    }

    function RegisterStudent(uint256 enrollment, string memory name) external {
        require(!students[enrollment].itExists, "Student already registered");
        require(bytes(name).length > 0, "Name cannot be empty");

        students[enrollment] = Student({
            privateName: name,
            enrollment: enrollment,
            itExists: true
        });

        emit StudentRegistered(enrollment, msg.sender);
    }

    struct Professor {
        string name;
        address professor_addr;
        bool itExists;
    }

    mapping(address => Professor) public professors;

    event ProfessorRegistered(address indexed sender_addr);

    modifier onlyProfessor(uint256 identifier) {
        require(professors[msg.sender].itExists, "Professor not found");
        require(msg.sender != address(0), "Invalid address");
        _;
    }

    function RegisterProfessor(string memory name) external {
        require(
            !professors[msg.sender].itExists,
            "Professor already registered"
        );
        require(bytes(name).length > 0, "Name cannot be empty");

        professors[msg.sender] = Professor({
            name: name,
            itExists: true,
            professor_addr: msg.sender
        });

        emit ProfessorRegistered(msg.sender);
    }

    struct Course {
        string name;
        string code; // Should use the type used by the university
        bool itExists;
    }

    mapping(string => Course) public courses;

    event CourseRegistered(string indexed code, address indexed sender_addr);

    function RegisterCourse(string memory name, string memory code) external {
        require(
            professors[msg.sender].itExists,
            "Only registered professors can perform this action"
        );
        require(!courses[code].itExists, "Course already registered");

        courses[code] = Course({name: name, code: code, itExists: true});

        emit CourseRegistered(code, msg.sender);
    }

    struct Class {
        string courseCode;
        address professor;
        uint256[] enrolledStudents;
        uint256 id;
        bool itExists;
    }

    uint256 public nextClassId = 1;

    mapping(uint => Class) public classes;

    event ClassRegistered(uint256 indexed id, address indexed sender_addr);

    function RegisterClass(string memory courseCode) external {
        require(
            professors[msg.sender].itExists,
            "Only registered professors can perform this action"
        );
        require(courses[courseCode].itExists, "This course does not exist");

        classes[nextClassId] = Class({
            courseCode: courseCode,
            professor: msg.sender,
            enrolledStudents: new uint256[](0),
            itExists: true,
            id: nextClassId
        });

        emit ClassRegistered(nextClassId, msg.sender);

        nextClassId++;
    }
}
