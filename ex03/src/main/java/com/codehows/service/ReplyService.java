package com.codehows.service;

import java.util.List;

import com.codehows.domain.Criteria;
import com.codehows.domain.ReplyVO;

public interface ReplyService {
	
	//mapper 안에 insert
	public int register(ReplyVO vo);
	
	//mapper 안에 read
	public ReplyVO get(Long rno);
	
	//mapper 안에 update
	public int modify(ReplyVO vo);
	
	//mapper 안에 delete
	public int remove(Long rno);
	
	//mapper 안에 getListWithPaging
	public List<ReplyVO> getList(Criteria cri, Long bno);
}
