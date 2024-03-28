package com.codehows.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {
	@GetMapping("/accessError")
	//Model은 java에서 view로 값을 전달하는 용도
	//java에서 java로 값을 전달할 때는 DTO를 사용
	//DB에서 java로 값을 전달할 때는 VO, VO를 list, set으로 이용
	//view에서 view로 값을 전달할 때는 파라미터(param)
	public void accessDenied(Authentication auth, Model model) {
		log.info("access Denied : " + auth);
		
		model.addAttribute("msg", "Access Denied");
	}
	
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		log.info("error: " + error);
		log.info("logout: " + logout);
		
		if(error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "꺼지쇼");
		}
	}
	
	//Logout.jsp에서 post 방식으로 보내지만 post는 security 내부에서 처리하고
	//logoutGet()에 인자가 아무것도 없으니 그냥 log 띄우는 용도
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("custom logout");
	}
	
	//여기에는 SampleController에 있는 RequestMapping이 없음
	//없으면 기본 시작이 localhost:8080/ 가 되어짐.
	
	//SampleController	localhost:8080/sample/
	//CommonController	localhost:8080/accessError/
	//HomeController	localhost:8080/
	
}
