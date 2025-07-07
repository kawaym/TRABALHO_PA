const { expect } = require("chai");

describe("DegreeSystem", function () {
    let degreeSystem, professor, student1, student2;

    beforeEach(async () => {
        [owner, professor, student1, student2] = await ethers.getSigners();
        const DegreeSystem = await ethers.getContractFactory("DegreeSystem");
        degreeSystem = await DegreeSystem.deploy();

        await degreeSystem.connect(professor).RegisterProfessor("Prof. Alice");
        await degreeSystem.connect(student1).RegisterStudent(1001, "Student One");
        await degreeSystem.connect(student2).RegisterStudent(1002, "Student Two");

        await degreeSystem.connect(professor).RegisterCourse("Math", "M101");
        await degreeSystem.connect(professor).RegisterClass("M101");
    });

    it("should enroll a student", async () => {
        await degreeSystem.connect(student1).enrollStudent(1, 1001);
        const enrolled = await degreeSystem.isStudentEnrolled(1, 1001);
        expect(enrolled).to.be.true;
    });

    it("should assign and alter degree", async () => {
        await degreeSystem.connect(student1).enrollStudent(1, 1001);
        await degreeSystem.connect(professor).assignDegree(1, 1001, 900);
        let [value] = await degreeSystem.seeDegree(1, 1001);
        expect(value).to.equal(900);

        await degreeSystem.connect(professor).alterDegree(1, 1001, 800);
        [value] = await degreeSystem.seeDegree(1, 1001);
        expect(value).to.equal(800);
    });

    it("should list all degrees for all enrolled students in a class", async () => {
        // Enroll and assign degrees
        await degreeSystem.connect(student1).enrollStudent(1, 1001);
        await degreeSystem.connect(student2).enrollStudent(1, 1002);

        await degreeSystem.connect(professor).assignDegree(1, 1001, 900);
        await degreeSystem.connect(professor).assignDegree(1, 1002, 750);

        const result = await degreeSystem.connect(professor).seeAllDegreesClass(1);

        const enrollments = result[0].map(n => Number(n));
        const values = result[1].map(n => Number(n));

        expect(enrollments).to.include.members([1001, 1002]);
        expect(values).to.include.members([900, 750]);
    });
});
