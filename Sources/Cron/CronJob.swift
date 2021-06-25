//
//  CronJob.swift
//  Cronexpr
//
//  Created by Safx Developer on 2015/12/06.
//  Copyright © 2015年 Safx Developers. All rights reserved.
//

import Dispatch

public class CronJob {
    public let pattern: DatePattern
    let job: () -> Void
    let queue: DispatchQueue

    public init(pattern: String, hash: Int64 = 0, job: @escaping () -> Void) throws {
        self.pattern = try DatePattern(pattern, hash: hash)
        self.job = job
        self.queue = DispatchQueue.main

        start()
    }

    public init(pattern: String, queue: DispatchQueue, hash: Int64 = 0, job: @escaping () -> Void) throws {
        self.pattern = try DatePattern(pattern, hash: hash)
        self.job = job
        self.queue = queue

        start()
    }

    public init(pattern: DatePattern, hash: Int64 = 0, job: @escaping () -> Void) {
        self.pattern = pattern
        self.job = job
        self.queue = DispatchQueue.main

        start()
    }

    public init(pattern: DatePattern, queue: DispatchQueue, hash: Int64 = 0, job: @escaping () -> Void) {
        self.pattern = pattern
        self.job = job
        self.queue = queue

        start()
    }

    public func start() {
        guard let next = pattern.next()?.date else {
            print("No next execution date could be determined")
            return
        }

        let interval = next.timeIntervalSinceNow
        queue.asyncAfter(deadline: .now() + interval) { [weak self] () -> () in
            self?.job()
            self?.start()
        }
    }
}
