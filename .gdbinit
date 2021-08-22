handle SIGUSR1 noprint nostop

define pSeeTimerPool
  set var $n = NumIndexes
  set var $i = 0
  while $i<=$n
    p *(GeneralPurposeTimerPoolEntry *)TimerArray[$i].mHeader->mpNext
    set var $i = $i + 1
  end
end

define pCalllegTransitionBuf
  set var $n = $arg0->mTranstions.index
  set var $i = 1
  while $i<=$n
    p $arg0->mTranstions.transitionArray.Array[$i]
    set var $i = $i + 1
  end
end

define pHistArrayForAllThreads2
#set max-value-size unlimited
  set var $ThreadIter = $arg0
  set var $ThreadsNum = HistoryLoggingManager::m_sLoggingManager->m_NumOfItemsInArray
  while ($ThreadIter < $ThreadsNum)
    if(HistoryLoggingManager::m_sLoggingManager->m_ppArray[$ThreadIter])
        print "Thread "
        print $ThreadIter
        print "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _"
        pHistArray2 HistoryLoggingManager::m_sLoggingManager->m_ppArray[$ThreadIter]
    end
    set var $ThreadIter = $ThreadIter + 1
  end
end


define pHistArray2
#  set max-value-size unlimited
  set var $Array = $arg0
  set var $n = 0
  set var $Max = $Array->m_pHistoryArray->m_ArrayAllocSize
  if($Array->m_pHistoryArray->m_ArrayExceeded == 0)
    set var $Max = $Array->m_pHistoryArray->m_CurrentPos
  end
  while ($n<$Max && $Array->m_pHistoryArray->m_pArray[$n].m_TimeOccur != 0)
    p $Array->m_pHistoryArray->m_pArray[$n]
    set var $n = $n + 1
  end
end

define pHistArrayForAllThreads
#  set max-value-size unlimited
  set var $ThreadIter = $arg0
  set var $ThreadsNum = $arg1
  while ($ThreadIter <= $ThreadsNum)
    thread $ThreadIter
    if(HISTORYLOG_g_Thread)
        pHistArray
    end
    set var $ThreadIter = $ThreadIter + 1
  end
end


define pHistArray
#  set max-value-size unlimited
  set var $n = 0
  set var $Max = HISTORYLOG_g_Thread->m_pHistoryArray->m_ArrayAllocSize
  if(HISTORYLOG_g_Thread->m_pHistoryArray->m_ArrayExceeded == 0)
    set var $Max = HISTORYLOG_g_Thread->m_pHistoryArray->m_CurrentPos
  end
  while ($n<$Max && HISTORYLOG_g_Thread->m_pHistoryArray->m_pArray[$n].m_TimeOccur != 0)
    p HISTORYLOG_g_Thread->m_pHistoryArray->m_pArray[$n]
    set var $n = $n + 1
  end
end

define pTempHistArray
#  set max-value-size unlimited
  set var $n = 0
  set var $Max = HISTORYLOG_g_Thread->m_pTempHistoryArray->m_ArrayAllocSize
  if(HISTORYLOG_g_Thread->m_pTempHistoryArray->m_ArrayExceeded == 0)
    set var $Max = HISTORYLOG_g_Thread->m_pTempHistoryArray->m_CurrentPos
  end
  while ($n<$Max && HISTORYLOG_g_Thread->m_pTempHistoryArray->m_Array[$n].m_TimeOccur != 0)
    p HISTORYLOG_g_Thread->m_pTempHistoryArray->m_Array[$n]
    set var $n = $n + 1
  end
end

define pRealtimeArrayForAllThreads
#  set max-value-size unlimited
  set var $ThreadIter = $arg0
  set var $ThreadsNum = $arg1
  while ($ThreadIter <= $ThreadsNum)
    thread $ThreadIter
    if(REALTIMETHREADMONITOR_pThis)
        p $ThreadIter
        p *REALTIMETHREADMONITOR_pThis
    end
    set var $ThreadIter = $ThreadIter + 1
  end
end

define pRealtimeArray
  set var $n = 0 
  while $n<m_NumberOfMonitoredThreads
    p *m_ppMonitorThreads[$n]
    set var $n = $n + 1
  end
end

define plist
  set var $n = $arg0->Head
  while $n
    if ($n->Data)
    {
       p *($n->Data)
    }
    set var $n = $n->Next
  end
end


define pBuffReuselist
  set var $n = ((MemMngrBufferReusageBlock *)($arg0))->m_HeadBufferReusageBlock->m_NextHeapBlock
  while $n
    if ($n->m_NextHeapBlock)
       p *($n->m_NextHeapBlock)
    set var $n = $n->m_NextHeapBlock
    end
  end
end

define LoopArrayAndPrintNonNull
  set var $Max = $arg0
  set var $Array = $arg1
  set var $n = 0
  while ($n<$Max)
    if($Array[$n].$arg2 != 0)
        p $n
        p $Array[$n]
    end
    set var $n = $n + 1
    if($n%100==0)
        p $n
    end
  end
end
