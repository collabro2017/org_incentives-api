# Overview
Optio Incentives provides a B2B SaaS solution for handling matter related to equity-based incentive (compensation) programs. Employee stock option programs are probably the most well-known, but we work on other financial instruments as well (RSUs, RSAs, warrants). 

Our typical client is listed on a stock exchange and has around 60-100 employees in their compensation programs (typically only people in higher management positions receive equity). But we work with smaller companies and startups as well. 

For our clients, we deliver an employee portal in which the employees can view the value of their given instruments, accept/sign legal documents (when they are given options for instance), exercise their options, and purchase financial instruments. We also deliver accounting reports from our system, required by the European accounting standard IFRS2. 

Next steps software wise is to create a document generator. Its first application is to create the legal documents for each employee in an incentive program, populating details based on data in the system. 

In addition to software, we provide counseling around the subject. We often help clients launch a new program (decide what to give), draft legal documents, and much more. 

# Mission

**Employee portal:** Intuitively show employees what financial instruments they have, what they are/mean, how much they are worth, and what/when they can do something about it. The employee portal should be a learning platform for everyone, demystify everything, and no financial background should be needed to understand what's going on.

**Client admin portal (does not exist yet):** Clients should be able to service themselves using our system, with simple, streamlined processes to minimize support requests. Allow/force our clients to update data in our system, so our overhead decreases and the client takes more responsibility for their data in our system. Allow the client admin to view data in our system to avoid unnecessary support requests. 

**Admin portal:** Automate everything, so our manual overhead on client work is minimized. 

# Terminology

The main entities of our systems are as follows:
* **Tenant (Client):** Represents our client. Top-level entity.
* **Entity:** Represents an entity within a tenant. Typically, this is subsidiary companies, and are used for grouping employees (most importantly to group cost based on entities when reporting for accounting purposes).
* **Employee:** Self-explanatory. Has an account_id which refers to an Auth0 user.
* **Incentive Program:** Top-level component for a compensation/incentive program. Typically, a decision to grant financial instruments is approved at a board meeting and this can result in a new Incentive Program in our system.
* **Incentive Sub Program:** An Incentive Program has potentially many Sub Programs, where each Sub Program has information about the specific financial instrument in use here (Option, RSU, RSA, Warrant), and the typical vesting structure for Awards in the Sub Program (Incentive Sub Program Template). 
* **Award:** A Sub Program has many Awards. An Award belongs to an employee and may contain many Vesting Events (sometimes referred to as Tranches).
* **Vesting Event (Tranche):** An Award has one or more Vesting Events. The Vesting Event holds information on when the instrument was granted, when it vests (is earned), when it expires, how much the agreed strike price is (the price for turning the option into a share), the granted quantity, and more. 
* **Transaction:** A Vesting Event has many Transactions. It's the Transactions that make up the current state of the Vesting Event. Transactions are used to have an audit log of all changes to a Vesting Event, which is needed for a complete audit of our accounting reports to be possible. 
* **Order:** We have two possible order types: Exercise and Purchase. Exercise is the process of turning an option or warrant into a share. In order to do this, the option has to be fully vested, an exercise window (determined by our client) must be open, and the employee has to finance the payment of the strike price. For those without financing to cover the strike price, we have an agreement with a bank to finance the strike price on behalf of the employee, allowing the employee to receive the remaining shares (after strike price is covered) – called "Exercise and sell to cover" – or to only receive cash ("Exercise and sell"). A Purchase order is simply a purchase of a financial instrument.

# Architecture Overview

The system consists of two repositories, incentives-api, and incentives-frontend. The frontend repository contains both the admin portal and employee portal, and the API repository contains the backend API code. 

**Incentives API:** Ruby on Rails API application with Postgres. Written by a Ruby noob (Aleksander).

**Incentives Frontend:** React.js and TypeScript application. Other libraries used: Redux, Saga, fetch, React Router, Webpack.
