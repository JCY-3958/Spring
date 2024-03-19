package com.codehows.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

import com.codehows.domain.ReplyVO;
import com.codehows.domain.Criteria;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	private Long[] bnoArr = { 655376L, 655375L, 655374L, 655372L, 655371L };
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;

	/*
	@Test
	public void testCreate() {
		IntStream.rangeClosed(1, 10).forEach(i -> {
			ReplyVO vo = new ReplyVO();
			
			vo.setBno(bnoArr[i % 5]);
			vo.setReply("댓글 테스트" + i);
			vo.setReplyer("replyer" + i);
			
			mapper.insert(vo);
		});
	}
	*/
	
	/*
	@Test
	public void testMapper() {
		log.info(mapper);
	}
	*/
	
	/*
	@Test
	public void testRead() {
		Long targetRno = 4L;
		
		ReplyVO vo = mapper.read(targetRno);
		
		log.info(vo);
	}
	*/
	
	/*
	@Test
	public void testDelete() {
		Long targetRno = 1L;
		
		mapper.delete(targetRno);
	}
	*/
	
	/*
	@Test
	public void testUpdate() {
		Long targetRno = 10L;
		
		ReplyVO vo = mapper.read(targetRno);
		
		vo.setReply("Update Reply");
		
		int count = mapper.update(vo);
		
		log.info("Update count : " + count);
	}
	*/
	
	@Test
	public void testList() {
		Criteria cri = new Criteria();
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
		
		replies.forEach(reply -> log.info(reply));
	}
}
