package com.codehows.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	
	/*
	 * execution ( ) 안에 * 다음에 띄워쓰기 해야함
	 */
	
	@Before("execution(* com.codehows.service.SampleService*.*(..))")
	//SampleService가 실행되기 전에 실행
	public void logBefore() {
		log.info("=======================");
	}
	
	@Before("execution(* com.codehows.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBeforeWithParam(String str1, String str2) {
		log.info("str1: " + str1);
		log.info("str2: " + str2);
	}
	
	@AfterThrowing(pointcut = "execution(* com.codehows.service.SampleService*.*(..))",
			throwing="exception")
	public void logException(Exception exception) {
		log.info("Exception..!!");
		log.info("exception: " + exception);
	}
	
	@Around("execution(* com.codehows.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		
		log.info("Target: " + pjp.getTarget()); // 메서드 객체
		log.info("Param: " + Arrays.toString(pjp.getArgs())); //메서드 매개변수 확인
		
		//invoke method
		//리턴 초기화
		Object result = null;
		
		try {
			result = pjp.proceed(); // 메서드 실행 -> 결과 값을 result 저장
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis(); // 메서드 실행 수 시간 값
		
		log.info("TIME: " + (end - start)); // 메서드가 실행하는데 걸린 시간
		
		return result;
	}
}
