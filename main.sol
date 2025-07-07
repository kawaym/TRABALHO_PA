// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegreeSystem {
    // DATA STRUCTURES
    struct Student {
        string privateName;
        uint256 enrollment;
        bool itExists;
    }

    struct Degree {
        uint256 classId;
        uint256 studentEnrollment;
        uint256 value;
        bool itExists;
    }

    struct Professor {
        string name;
        address professor_addr;
        bool itExists;
        uint256[] classesIds;
    }

    struct Course {
        string name;
        string code; // Should use the type used by the university
        bool itExists;
    }

    struct Class {
        string courseCode;
        address professor;
        uint256[] enrolledStudents;
        uint256 id;
        bool itExists;
    }

    // MAPPINGS
    mapping(uint256 => Student) public students;
    mapping(bytes32 => Degree) public degrees;
    mapping(address => Professor) public professors;
    mapping(string => Course) public courses;
    mapping(uint => Class) public classes;

    // EVENTS
    event StudentRegistered(
        uint256 indexed enrollment,
        address indexed sender_addr
    );
    event ProfessorRegistered(address indexed sender_addr);
    event CourseRegistered(string indexed code, address indexed sender_addr);
    event ClassRegistered(uint256 indexed id, address indexed sender_addr);

    // MODIFIERS
    modifier onlyStudent(uint256 enrollment) {
        require(
            students[enrollment].itExists,
            "Only registered students can perform this action"
        );
        require(msg.sender != address(0), "Invalid address");
        _;
    }

    modifier onlyProfessor() {
        require(
            professors[msg.sender].itExists,
            "Only registered professors can perform this action"
        );
        require(msg.sender != address(0), "Invalid address");
        _;
    }

    // UTILS
    uint256 public nextClassId = 1;

    // FUNCTIONS
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

    function RegisterProfessor(string memory name) external {
        require(
            !professors[msg.sender].itExists,
            "Professor already registered"
        );
        require(bytes(name).length > 0, "Name cannot be empty");

        professors[msg.sender] = Professor({
            name: name,
            itExists: true,
            professor_addr: msg.sender,
            classesIds: new uint256[](0)
        });

        emit ProfessorRegistered(msg.sender);
    }

    function RegisterCourse(
        string memory name,
        string memory code
    ) external onlyProfessor {
        require(!courses[code].itExists, "Course already registered");

        courses[code] = Course({name: name, code: code, itExists: true});

        emit CourseRegistered(code, msg.sender);
    }

    function RegisterClass(string memory courseCode) external onlyProfessor {
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
