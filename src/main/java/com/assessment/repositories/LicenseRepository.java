package com.assessment.repositories;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.assessment.data.License;
import com.assessment.data.Module;
import com.assessment.data.User;

public interface LicenseRepository extends JpaRepository<License,Long>{

	
	@Query("SELECT c FROM License c WHERE c.licenseName=:licenseName and c.companyId=:companyId")
	License findByPrimaryKey(@Param("licenseName") String licenseName,  @Param("companyId") String companyId);
	
	@Query("SELECT c FROM License c WHERE c.companyId=:companyId")
	List<License> getLicensesByCompany(@Param("companyId") String companyId);
	
	@Query("SELECT c.licenseName FROM License c WHERE c.companyId=:companyId")
	List<String> getLicensesInStringByCompany(@Param("companyId") String companyId);
	
	@Query(value="SELECT l FROM License l WHERE l.companyId=:companyId")
	public Page<License> getLicenses(@Param("companyId") String companyId, Pageable pageable);
	
	@Query("SELECT c FROM License c WHERE c.companyId=:companyId and c.free = true")
	List<License> getFreeLicensesByCompany(@Param("companyId") String companyId);
	
	@Query("SELECT q FROM License q WHERE q.companyId=:companyId and ( q.licenseName LIKE %:searchText%  OR q.licenseDesc LIKE %:searchText%  OR q.licenseImage LIKE %:searchText% )")
	Page<License> searchLicenses(@Param("companyId") String companyId, @Param("searchText")  String searchText,Pageable pageable);

}
