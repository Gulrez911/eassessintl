package com.assessment.data;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement(name="test-cases") 
public class TestCases {
	
	List<TestCase> cases = new ArrayList<TestCase>();

	public List<TestCase> getCases() {
		return cases;
	}

	public void setCases(List<TestCase> cases) {
		this.cases = cases;
	}

	
	
	

}
