// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegreeSystem {
    // DATA STRUCTURES
    struct Student {
        string privateName;
        uint256 enrollment;
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

    struct Degree {
        uint256 classId;
        uint256 studentEnrollment;
        uint256 value;
        bool itExists;
    }

    // MAPPINGS
    mapping(uint256 => Student) public students;
    mapping(address => Professor) public professors;
    mapping(string => Course) public courses;
    mapping(uint => Class) public classes;
    mapping(bytes32 => Degree) public degrees;

    // EVENTS
    event StudentRegistered(
        uint256 indexed enrollment,
        address indexed sender_addr
    );
    event ProfessorRegistered(address indexed sender_addr);
    event CourseRegistered(string indexed code, address indexed sender_addr);
    event ClassRegistered(uint256 indexed id, address indexed sender_addr);
    event StudentWasEnrolled(
        uint256 indexed classId,
        uint256 indexed studentEnrollment
    );
    event degreeWasAssigned(
        uint256 indexed classId,
        uint256 indexed studentEnrollment,
        uint256 degree
    );
    event degreeWasAltered(
        uint256 indexed classId,
        uint256 indexed studentEnrollment,
        uint256 oldDegree,
        uint256 degree
    );

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

    modifier onlyClassProfessor(uint256 classId) {
        require(classes[classId].itExists, "Class not found");
        require(
            classes[classId].professor == msg.sender,
            "Only the professors of this class can perform this action"
        );
        _;
    }

    modifier studentExists(uint256 studentEnrollment) {
        require(students[studentEnrollment].itExists, "Student not found");
        _;
    }

    modifier isValidDegree(uint256 degree) {
        require(degree <= 1000, "Degree must be between 0 and 1000");
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

    function enrollStudent(
        uint256 classId,
        uint256 studentEnrollment
    ) external onlyStudent(studentEnrollment) {
        uint256[] memory enrolled = classes[classId].enrolledStudents;
        for (uint256 i = 0; i < enrolled.length; i++) {
            require(
                classes[classId].enrolledStudents[i] != studentEnrollment,
                "Student already enrolled"
            );
        }

        classes[classId].enrolledStudents.push(studentEnrollment);

        emit StudentWasEnrolled(classId, studentEnrollment);
    }

    function assignDegree(
        uint256 classId,
        uint256 studentEnrollment,
        uint256 degree
    )
        external
        onlyProfessor
        onlyClassProfessor(classId)
        studentExists(studentEnrollment)
        isValidDegree(degree)
    {
        bytes32 hashDegree = keccak256(
            abi.encodePacked(classId, studentEnrollment)
        );
        require(
            !degrees[hashDegree].itExists,
            "Degree already assigned. Use alterDegree to alter"
        );

        degrees[hashDegree] = Degree({
            classId: classId,
            studentEnrollment: studentEnrollment,
            value: degree,
            itExists: true
        });

        emit degreeWasAssigned(classId, studentEnrollment, degree);
    }

    function alterDegree(
        uint256 classId,
        uint256 studentEnrollment,
        uint256 degree
    )
        external
        onlyProfessor
        onlyClassProfessor(classId)
        studentExists(studentEnrollment)
        isValidDegree(degree)
    {
        bytes32 hashDegree = keccak256(
            abi.encodePacked(classId, studentEnrollment)
        );
        require(
            !degrees[hashDegree].itExists,
            "Degree was not yet assigned. Use assignDegree to assign"
        );

        uint256 oldDegree = degrees[hashDegree].value;
        degrees[hashDegree].value = degree;

        emit degreeWasAltered(classId, studentEnrollment, oldDegree, degree);
    }
}
