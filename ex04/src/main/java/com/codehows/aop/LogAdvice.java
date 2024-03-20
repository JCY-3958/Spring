package com.codehows.aop;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	
	@Before("execution(* com.codehows.service.SampleService*.*(..))")
	//SampleService가 실행되기 전에 실행
	public void logBefore() {
		log.info("=======================");
	}
}
