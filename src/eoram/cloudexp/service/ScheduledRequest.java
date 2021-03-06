package eoram.cloudexp.service;

import eoram.cloudexp.data.DataItem;
import eoram.cloudexp.pollables.Completable;
import eoram.cloudexp.pollables.Pollable;
import eoram.cloudexp.utils.Errors;

/**
 * Represents a scheduled request.
 * <p><p>
 * A scheduled request represents a request that has been scheduled but may still be pending (i.e., not completed yet).
 */
public class ScheduledRequest extends Pollable implements Completable, Comparable<ScheduledRequest> 
{
	public int compareTo(ScheduledRequest anotherReq) 
	{
        return this.request.compareTo(anotherReq.request);
    }

	protected boolean completed = false;
	protected boolean success = false;
	protected Request request = null;
	
	protected DataItem dataItem = null;
	protected Pollable pending = null;
	
	public ScheduledRequest(Request req) { request = req; completed = false; success = false; dataItem = null; }
	
	public synchronized boolean isReady() 
	{
		if(pending != null)
		{
			if(pending.isReady() == true)
			{
				completed = true;
				pending = null;
			}
		}
		
		return completed;
	}

	public synchronized void onSuccess(DataItem d) 
	{
		completed = true;
		success = true;
		dataItem = d;
	}
	
	public synchronized void onFailure()
	{
		completed = true;
		success = false;
		dataItem = null;
		
		Errors.error("Request " + request.getId() + " failed -> Coding FAIL!");
	}
	
	public synchronized void onPendingSuccess(DataItem d, Pollable p)
	{
		pending = p;
		completed = isReady();
		success = true;
		dataItem = d;
	}

	public synchronized DataItem getDataItem() // will block until ready
	{
		waitUntilReady();
		return dataItem;
	}

	public synchronized boolean wasSuccessful() // will block until ready
	{
		if(completed == false) { waitUntilReady(); }
		return success;
	}

	public synchronized Request getRequest() { return request; }
}
