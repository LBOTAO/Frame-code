package cn.hibernate.day04mapping.manytoone;

/**
 * Created by Administrator on 2017/12/28.
 */
public class Dept {
    private Integer deptno;
    private String dname;

    public Integer getDeptno() {
        return deptno;
    }

    public void setDeptno(Integer deptno) {
        this.deptno = deptno;
    }

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }
}