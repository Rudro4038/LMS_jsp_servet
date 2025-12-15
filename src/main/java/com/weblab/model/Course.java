package com.weblab.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Course implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String description;
    private int teacherId;
    private String teacherName;
    private int capacity;
    private int enrolledCount;
    private Timestamp createdDate;
    private String status;

    // Constructors
    public Course() {
    }

    public Course(String name, String description, int teacherId, int capacity) {
        this.name = name;
        this.description = description;
        this.teacherId = teacherId;
        this.capacity = capacity;
        this.status = "active";
    }

    public Course(int id, String name, String description, int teacherId, int capacity, 
                  Timestamp createdDate, String status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.teacherId = teacherId;
        this.capacity = capacity;
        this.createdDate = createdDate;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public int getEnrolledCount() {
        return enrolledCount;
    }

    public void setEnrolledCount(int enrolledCount) {
        this.enrolledCount = enrolledCount;
    }

    public boolean hasAvailableSeats() {
        return enrolledCount < capacity;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", teacherId=" + teacherId +
                ", status='" + status + '\'' +
                '}';
    }
}
