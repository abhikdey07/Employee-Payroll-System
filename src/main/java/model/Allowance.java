package model;

public class Allowance {
    private int empId;
    private double overtime;
    private double medical;
    private double bonus;
    private double other;
    private double totalOvertimeRate;
    private double rphRate;

    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }
    public double getOvertime() { return overtime; }
    public void setOvertime(double overtime) { this.overtime = overtime; }
    public double getMedical() { return medical; }
    public void setMedical(double medical) { this.medical = medical; }
    public double getBonus() { return bonus; }
    public void setBonus(double bonus) { this.bonus = bonus; }
    public double getOther() { return other; }
    public void setOther(double other) { this.other = other; }
    public double getTotalOvertimeRate() { return totalOvertimeRate; }
    public void setTotalOvertimeRate(double totalOvertimeRate) { this.totalOvertimeRate = totalOvertimeRate; }
    public double getRphRate() { return rphRate; }
    public void setRphRate(double rphRate) { this.rphRate = rphRate; }
}
